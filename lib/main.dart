import 'package:flutter/material.dart';
import 'screen/MainPage.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     theme :ThemeData(
    primarySwatch:Colors.blue,
),
      home: MainPage());
  }
}