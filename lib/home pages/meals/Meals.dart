import 'package:flutter/material.dart';
class Meals extends StatefulWidget {
  Meals({Key  key}) : super(key: key);

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: Text("meals"),)),
    );
  }
}