import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../components/globals.dart' as globals;

class Done extends StatefulWidget {
  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {
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
    void changeBrightness() {
      DynamicTheme.of(context).setBrightness(
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark);
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'المهام المكتملة',
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
              child: ListView.builder(
                itemCount: globals.done.length,
                itemBuilder: (context, index) {
                  final item = globals.done[index];
                  return Card(
                    elevation: 3,
                    child: styleToDo(item),
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
