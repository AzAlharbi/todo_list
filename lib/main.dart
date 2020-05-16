import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:Todo/screens/done.dart';

import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
              fontFamily: 'Tajawal',
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
              title: 'ToDO',
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: HomeScreen());
          // routes: {
          //   '/': (context) => HomeScreen(),

          //   '/third': (context) => Done(),
          // });
        });
  }
}
