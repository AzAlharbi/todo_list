import 'package:flutter/material.dart';
import '../components/globals.dart' as globals;
import '../Service/db.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    super.initState();
    TodoProvider().init();
  }

  Widget styleToDo(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Flexible(
          child: new Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 50,
            child: Text(
              title,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'قائمة المهام',
            style: TextStyle(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black
                    : Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
              future: TodoProvider().getAllTodo(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (snapshot.data == null) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                } else {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data[index].columnTitle;
                          return Dismissible(
                            child: Card(
                              elevation: 3,
                              child: styleToDo(item),
                            ),
                            key: ValueKey(item),
                            background: Container(
                              padding: EdgeInsets.only(left: 30),
                              color: Colors.green,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              padding: EdgeInsets.only(right: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                setState(() {
                                  //globals.data.removeAt(index);
                                  TodoProvider()
                                      .delete(snapshot.data[index].id);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "($item) حُذفت ",
                                      textDirection: TextDirection.rtl,
                                    ),
                                    action: SnackBarAction(
                                      label: 'تراجع',
                                      onPressed: () {
                                        globals.data.add(item);
                                        (context as Element).reassemble();
                                      },
                                    ),
                                  ));
                                });
                              } else {
                                setState(() {
                                  //globals.done.add(item);
                                  // globals.data.removeAt(index);
                                  Todo updateTodo = Todo(
                                      title: snapshot.data[index].title,
                                      done: true);
                                  TodoProvider().update(updateTodo);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "($item) قد إكتملت!",
                                      textDirection: TextDirection.rtl,
                                    ),
                                    action: SnackBarAction(
                                      label: 'تراجع',
                                      onPressed: () {
                                        globals.data.add(item);
                                        globals.done.removeLast();
                                        (context as Element).reassemble();
                                      },
                                    ),
                                  ));
                                });
                              }
                            },
                          );
                        },
                      );
                    } else {
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "لايوجد مهام :(",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
