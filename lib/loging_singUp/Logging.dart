import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:medical/home%20pages/userHome.dart';

import '../models.dart';

class Logging extends StatefulWidget {
  Logging({Key key}) : super(key: key);

  @override
  _LoggingState createState() => _LoggingState();
}

class _LoggingState extends State<Logging> {
  TextEditingController useremail = TextEditingController();
  TextEditingController userpass = TextEditingController();
  GlobalKey<FormState> formstat = new GlobalKey<FormState>();
  bool userFound;

  //عرض الايقون المناسب لكلمه المرور
  bool hintpassText = true;

  Icon hintpass = Icon(
    Icons.remove_red_eye_rounded,
    color: Colors.blue,
  );

  Icon showpass = Icon(
    Icons.visibility_off,
    color: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
//التظليل--------------------------------------------------------------------
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rec) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black, Colors.black45],
            ).createShader(rec),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assist/b2.jpg"),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
            ),
          ),
// body-------------------------------------------------------------
          Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                height: height,
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 40,
                  ),
                  height: height / 2.5,
                  width: double.infinity,
                  child: Form(
                    key: formstat,
                    
                    child: SingleChildScrollView(
                      child: Column(
//الحقووول-------------------------------
                        children: [
                          Container(
                            height: height / 4,
                            child: Lottie.asset("lib/lottie/user-card.json"),
                          ),
//البريد الالكتروني--------------------------------------------------------------------
                          textFromField(
                              Icon(Icons.email, color: Colors.red[900]),
                              Icon(Icons.add, size: 0),
                              "أدخل البريد الالكتروني",
                              false,
                              useremail,
                              valedEmile,
                              14.0),
                          SizedBox(height: 10),
//كلمه السر--------------------------------------------------------------------
                          textFromField(
                              Icon(Icons.lock, color: Colors.amber[900]),
                              IconButton(
                                  icon: hintpassText ? hintpass : showpass,
                                  onPressed: () {
                                    setState(() {
                                      hintpassText = !hintpassText;
                                    });
                                  }),
                              "أدخل كلمة المرور",
                              hintpassText,
                              userpass,
                              validPassword,
                              14.0),
                          SizedBox(height: 10),
//logging buttom---------------------------------------------------------------------
                          Container(
                            width: double.infinity,
                            child: RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: appColor,
                                icon: Icon(Icons.login),
                                label: Text(" تسجيل الدخول",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  //call logging Method
                                  logging(useremail.text, userpass.text);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------
  logging(String emile, String pass) async {
    var formdata = formstat.currentState;

    if ((formdata.validate()) == true) {
      try {
        lodding(context, "تسجيل الدخول");
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emile.trim(), password: pass);
       
        if (userCredential != null) {
          // Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserHome()));
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'user-not-found') {
          showDialogMethod(context, "تسجيل الدخول", "المستخدم غير موجود");
        } else if (e.code == 'wrong-password') {
          showDialogMethod(context, "تسجيل الدخول", "المستخدم غير موجود");
        }
      }
    } else {
      showDialogMethod(context, "تسجيل الدخول", "املء الحقول اعلاها");
    }
  }
}
