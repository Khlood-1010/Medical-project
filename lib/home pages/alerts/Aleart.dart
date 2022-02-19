
import 'package:flutter/material.dart';


class Aleart extends StatefulWidget {
  Aleart({Key key}) : super(key: key);

  @override
  _AleartState createState() => _AleartState();
}

class _AleartState extends State<Aleart> {


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Text("التنبهات");
  }

 }
