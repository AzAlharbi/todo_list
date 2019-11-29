import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../components/globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _addController = new TextEditingController();
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
    void changeBrightness() {
      DynamicTheme.of(context).setBrightness(
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark);
    }

    return Scaffold(
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
              Icons.done,
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Colors.black54
                  : Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/third');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Colors.black54
                  : Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/second');
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
      body: Container(
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'ToDo List',
              style: TextStyle(
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? Colors.black54
                      : Colors.white,
                  fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: globals.data.length,
                itemBuilder: (context, index) {
                  final item = globals.data[index];
                  return Dismissible(
                    child: Card(
                      elevation: 3,
                      child: styleToDo(item),
                    ),
                    key: ValueKey(item),
                    background: Container(
                      color: Colors.green,
                      child: Icon(Icons.check),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Icon(Icons.cancel),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        setState(() {
                          globals.data.removeAt(index);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("$item deleted"),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                globals.data.add(item);
                              },
                            ),
                          ));
                        });
                      } else {
                        setState(() {
                          globals.done.add(item);
                          globals.data.removeAt(index);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("$item is done!"),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                globals.data.add(item);
                                globals.done.removeLast();
                              },
                            ),
                          ));
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
