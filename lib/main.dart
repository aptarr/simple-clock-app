import 'package:flutter/material.dart';
import 'package:simple_clock_apps/alarm_home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // MaterialApp is at the top of the widget tree
      home: AlarmHome(), // Set MyHomePage as the initial page
    );
  }
}
