import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Service/db.dart';
import 'package:todo_list/screens/done.dart';
import '../components/globals.dart' as globals;
import 'toDoList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _addController = new TextEditingController(text: '');
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  static List<Widget> _widgetOptions = <Widget>[
    TodoList(),
    Done(),
  ];
  void initState() {
    super.initState();
    TodoProvider().init();
  }

  @override
  Widget build(BuildContext context) {
    void changeBrightness() {
      DynamicTheme.of(context).setBrightness(
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark);
      (context as Element).reassemble();
    }

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          brightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.light
              : Brightness.dark,
          centerTitle: false,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black54
                    : Colors.white,
                size: 40,
              ),
              onPressed: () {
                // Navigator.of(context).pushNamed('/second');
                _addNewToDo();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.lightbulb_outline,
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black54
                    : Colors.white,
                size: 40,
              ),
              onPressed: () {
                changeBrightness();
              },
            )
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          height: 50,
          backgroundColor: Theme.of(context).canvasColor,
          // color: Color(0xff1F2D57),
          color: Colors.black87,
          items: <Widget>[
            Icon(Icons.list, size: 30, color: Colors.white),
            Icon(Icons.done, size: 30, color: Colors.white),

            // Icon(
            //   Icons.add,
            //   size: 30,
            //   color: (Theme.of(context).brightness == Brightness.light)
            //       ? Colors.white
            //       : Colors.black,
            // ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          animationDuration: Duration(milliseconds: 300),
          index: 0,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_page),
        ));
  }

  final myColor = Colors.green.withOpacity(1.00);
  void _addNewToDo() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _modal());
        });
  }

  _modal() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'إضافة مهمة',
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
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextField(
              autofocus: true,
              controller: _addController,
              maxLines: 1,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                fillColor: Theme.of(context).canvasColor,
                filled: true,
                labelText: 'أدخل المهمة',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 0)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            // hoverColor: Colors.black,
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.cyan,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "إضافة",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            onPressed: () {
              if (_addController.text != null ||
                  _addController.text != "" ||
                  _addController.text != " ") {
                setState(() {
                  Todo newTodo =
                      new Todo(title: _addController.text, done: false);
                  TodoProvider().insert(newTodo);
                });
                _addController.clear();
                (context as Element).reassemble();
                Navigator.of(context).pop();
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
