import 'package:flutter/material.dart';

class ConcatUs extends StatefulWidget {
  ConcatUs({Key key}) : super(key: key);

  @override
  _ConcatUsState createState() => _ConcatUsState();
}

class _ConcatUsState extends State<ConcatUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: Text("concat us"),)),
    );
  }
}