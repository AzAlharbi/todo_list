import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableTodo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Todo {
  int id;
  String title;
  bool done;

  Todo({this.id, this.title, this.done});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database db;
  String path;

  Future init() async {
    String path = await getDatabasesPath();
    path = join(path, 'notes.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDone integer not null)
''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    if (todo.title.trim().isEmpty) todo.title = 'فارغه';
    todo.id = await db.insert(tableTodo, todo.toMap());
    print('done');
    // String title = todo.title;
    // bool done = todo.done;
    // db.rawInsert('INSERT INTO todo(title, done) VALUES($title,$done)');
    return todo;
  }
  //   Future<List<Map<String, dynamic>>> getTodoMapList() async {
  // 	Database db = await this.database;

  // 	//var result = await db.rawQuery('SELECT * FROM $tableTodo order by $colTitle ASC');
  // 	var result = await db.query(tableTodo, orderBy: '$columnDone 0');
  // 	return result;
  // }

  Future<Todo> getTodo(int id) async {
    await init();
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  // Future<List<Todo>> getAllTodo() async {
  //   await init();
  //   List<Map> list = await db.query(tableTodo,
  //       columns: [columnId, columnDone, columnTitle],
  //       where: '$columnDone = ?',
  //       whereArgs: [0]);
  //   List<Todo> todos = new List();
  //   for (int i = 0; i < list.length; i++) {
  //     Todo todo = new Todo();
  //     todo.id = list[i]['columnId'];
  //     todo.title = list[i]['columnTitle'];
  //     todo.done = list[i]['columnDone'];

  //     todos.add(todo);
  //   }
  //   return todos;
  // }
  Future<List<Map<String, dynamic>>> getAllTodo() async {
    await init();
    return await db.query(tableTodo);
  }

  Future<Todo> getDoneTodo() async {
    await init();
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnDone = ?',
        whereArgs: [1]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    await init();
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    await init();
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
