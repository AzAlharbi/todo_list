import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableTodo = 'todo';
final String doneTodo = 'doneTodo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Todo {
  int id;
  String title;
  bool done;

  Todo({this.id, this.title, this.done});

  Map<String, dynamic> toMap() =>
      {columnTitle: title, columnDone: done == true ? 1 : 0, columnId: id};

  factory Todo.fromMap(Map<String, dynamic> map) => new Todo(
        id: map[columnId],
        title: map[columnTitle],
        done: map[columnDone] == 1,
      );
}

class TodoProvider {
  Database db;
  String path;

  Future<Database> get database async {
    if (db != null) return db;

    db = await init();
    return db;
  }

  Future init() async {
    String path = await getDatabasesPath();
    path = join(path, 'Todo.db');

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
    await init();
    if (todo.title.trim().isEmpty) todo.title = 'فارغه';
    todo.id = await db.insert(tableTodo, todo.toMap());
    // String title = todo.title;
    // bool done = todo.done;
    // db.rawInsert('INSERT INTO todo(title, done) VALUES($title,$done)');
    print('Todo added: ${todo.title}');
    return todo;
  }

  Future<List<Todo>> getAllTodo() async {
    await init();
    // List<Map> maps =
    //     await db.query(tableTodo, columns: [columnId, columnDone, columnTitle]);
    List<Todo> todoList = [];
    // maps.forEach((maps) => todo.add(maps));
    // List<Map<String, dynamic>> todo = await db.query('todo');
    List<Map> todo = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnDone = ?',
        whereArgs: [0]);
    for (var i = 0; i < todo.length; i++) {
      todoList.add(Todo.fromMap(todo[i]));
    }
    return todoList;
  }

  Future<List<Todo>> getDoneTodo() async {
    await init();

    List<Todo> todoDoneList = [];

    // List<Map<String, dynamic>> todo = await db.query('doneTodo');
    List<Map> todo = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnDone = ?',
        whereArgs: [1]);
    for (var i = 0; i < todo.length; i++) {
      todoDoneList.add(Todo.fromMap(todo[i]));
    }
    return todoDoneList;
  }

  Future<int> delete(int id) async {
    await init();
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteDone() async {
    await init();
    return await db.delete(tableTodo, where: '$columnDone = ?', whereArgs: [1]);
  }

  Future<int> update(Todo todo) async {
    await init();
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
