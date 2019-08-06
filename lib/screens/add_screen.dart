import 'package:flutter/material.dart';
import '../components/globals.dart' as globals;
class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController _addController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                brightness: Theme.of(context).brightness == Brightness.light
                    ? Brightness.light
                    : Brightness.dark,
                centerTitle: false,
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
                title: Text(
                  'Add ToDo',
                  style: TextStyle(
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 40),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 40,
                    ),
                    onPressed: () {
                      if (_addController.text != null ||
                          _addController.text != "" ||
                          _addController.text != " ") {
                        setState(() {
                          globals.data.add(_addController.text);
                        });
                        _addController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
              body: Container(
                color: Theme.of(context).canvasColor,
                padding:
                    EdgeInsets.only(top: 40, right: 10, left: 10, bottom: 20),
                child: TextField(
                  controller: _addController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).canvasColor,
                    filled: true,
                    labelText: 'Enter ToDo',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 0)),
                  ),
                ),
              ));
  }
}