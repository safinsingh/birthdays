import 'package:flutter/material.dart';
import './birthday_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.blue[700]), home: BirthdayList());
  }
}
