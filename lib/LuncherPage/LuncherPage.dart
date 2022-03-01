

import 'package:flutter/material.dart';
import 'package:medical/loging_singUp/Logging.dart';
import 'package:medical/loging_singUp/SingUp.dart';

import '../models.dart';

class LuncherPage extends StatefulWidget {
  LuncherPage({Key key}) : super(key: key);

  @override
  _LuncherPageState createState() => _LuncherPageState();
}

class _LuncherPageState extends State<LuncherPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: appColor,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 40),
                child: Text("مرحبا بكم في تطبيق ",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
            Container(
               margin: EdgeInsets.only(top: 15,bottom: 10),
                child: Text("رعاية مرضى السكري ",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Quicksand"))),
            Expanded(
                flex: 7,
                child: ClipPath(
                  clipper: MyCliper(),
                  child: Container(
                      height: height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("lib/assist/b2.jpg"),
                            fit: BoxFit.cover),
                      )),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Logging()));
                          },
                          icon: Icon(Icons.login),
                          label: Text("تسجيل الدخول",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      RaisedButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => SingUp()));
                          },
                          icon: Icon(Icons.add),
                          label: Text("إنشاء حساب",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}


