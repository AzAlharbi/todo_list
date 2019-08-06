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
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ],
      ),
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
        title: Text(
          'ToDo List',
          style: TextStyle(
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Colors.black54
                  : Colors.white,
              fontSize: 40),
        ),
        actions: <Widget>[
          // Add 3 lines from here...
          IconButton(
            icon: Icon(
              Icons.add,
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Colors.black54
                  : Colors.white,
              size: 40,
            ),
            onPressed:(){ Navigator.of(context).pushNamed('/second');},
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
            Expanded(
              child: ListView.builder(
                itemCount: globals.data.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    child: Card(
                      elevation: 3,
                      child: styleToDo(globals.data[index]),
                    ),
                    key: ValueKey(globals.data[index]),
                    background: Container(
                      color: Colors.green,
                      child: Icon(Icons.check),
                    ),
                    onDismissed: (left) {
                      setState(() {
                        globals.data.removeAt(index);
                      });
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
