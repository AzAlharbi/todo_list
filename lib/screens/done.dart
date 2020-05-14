import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../components/globals.dart' as globals;
import '../Service/db.dart';

class Done extends StatefulWidget {
  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {
  TextEditingController _addController = new TextEditingController();

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
            decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(color: Colors.green, width: 5))),
            width: double.infinity,
            padding: EdgeInsets.only(right: 10),
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
              child: FutureBuilder(
                  future: TodoProvider().getDoneTodo(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data.length == 0) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "لايوجد مهام مكتملة :(",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data[index].title;
                          return Card(
                            elevation: 7,
                            child: styleToDo(item),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
