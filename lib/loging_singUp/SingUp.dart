import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


import '../models.dart';
import 'Logging.dart';

class SingUp extends StatefulWidget {
  SingUp({Key key}) : super(key: key);

  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
//استرجاع القيم داخل الحقول-----------------------------------------------------------------------
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController length = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController wiegth = TextEditingController();
  TextEditingController phone = TextEditingController();
  //
//-----------------------------------------------------------------------

  GlobalKey<FormState> formstat = new GlobalKey<FormState>();

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
    // var width = MediaQuery.of(context).size.width;
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
                    autovalidateMode: AutovalidateMode.always,
                    
                    child: SingleChildScrollView(
                      child: Column(
//الحقووول-------------------------------
                        children: [
                          Container(
                            height: height / 4,
                            child: Lottie.asset("lib/lottie/user-card.json"),
                          ),
                          SizedBox(height: 10),
//الاسم --------------------------------------------------------------------

                          textFromField(
                              Icon(Icons.person, color: Colors.blue[700]),
                              Icon(Icons.add, size: 0),
                              "أدخل الاسم",
                              false,
                              name,
                              validName,
                              14.0),
                          SizedBox(height: 10),
//البريد الالكتروني--------------------------------------------------------------------
                          textFromField(
                              Icon(Icons.email, color: Colors.red[900]),
                              Icon(Icons.add, size: 0),
                              "أدخل البريد الالكتروني",
                              false,
                              email,
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
                              pass,
                              validPassword,
                              14.0),
                          SizedBox(height: 10),
// الطول--------------------------------------------------------------------

                          textFromField(
                              Icon(Icons.accessibility_sharp,
                                  color: Colors.black),
                              Icon(Icons.accessibility_sharp, size: 0),
                              "أدخل الطول",
                              false,
                              length,
                              validLeAgWe,
                              14.0),
                          SizedBox(height: 10),
// الوزن--------------------------------------------------------------------

                          textFromField(
                              Icon(Icons.wc_sharp, color: Colors.pink),
                              Icon(Icons.add, size: 0),
                              "أدخل الوزن",
                              false,
                              wiegth,
                              validLeAgWe,
                              14.0),
                          SizedBox(height: 10),
//العمر --------------------------------------------------------------------

                          textFromField(
                              Icon(Icons.assignment_ind_rounded,
                                  color: Colors.brown),
                              Icon(Icons.add, size: 0),
                              "أدخل العمر",
                              false,
                              age,
                              validLeAgWe,
                              14.0),
                          SizedBox(height: 10),
// الرقم--------------------------------------------------------------------

                          textFromField(
                              Icon(Icons.call, color: Colors.redAccent[700]),
                              Icon(Icons.add, size: 0),
                              "أدخل رقم لحالات الطوارئ",
                              false,
                              phone,
                              valedPhone,
                              14.0),
                          SizedBox(height: 10),
// زر انشاء الحساب--------------------------------------------------------------------

                          Container(
                            width: double.infinity,
                            child: RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: appColor,
                                onPressed: () async {
                                  //call sing up method

                                  singUp(email.text, pass.text, length.text,
                                      wiegth.text, age.text, phone.text);
                                },
                                icon: Icon(Icons.add),
                                label: Text("إنشاء حساب",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))),
                          ),
// --------------------------------------------------------------------
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

//sing up method-----------------------------------------------------
  singUp(userEmile, userPass, userLength, userWight, userAge, phone) async {
    var formdata = formstat.currentState;
    if (formdata.validate()) {
      try {
        //يتم اضافه المستخدم الي قاعده البيانات
        lodding(context, "انشاء حساب");
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
           email: userEmile.trim(),
          password: userPass,
        );
        //في حاله تمت الاضافه بنجاح سيتولد ايدي للمستخدم فيجب اختبار القيمه
        var userID = userCredential.user.uid;

        if (userID != null) {
          User currentUser = FirebaseAuth.instance.currentUser;

          if (userCredential != null) {
            await FirebaseFirestore.instance.collection('user').add({
              "userID": currentUser.uid,
              'name': name.text,
              'Emile': userEmile,
              'pass': userPass,
              'length': userLength,
              'wight': userWight,
              'age': userAge,
              'phone': phone,
            })

                //التحقق ما اذا تمت العمليه بنجاح ام لا
                .then((value) {
              Navigator.pop(context);
              showOptionDaylog(
                  context, " انشاء حساب", "تمت العملية بنجاح هل تريد الذهاب الي صفحة تسجيل الدخول؟", Logging());
            }).catchError((e) {
              Navigator.pop(context);
              showDialogMethod(
                  context, "انشاء حساب", "حصلت مشكلة في قاعدة البيانات");
            });
          }
          // يتم تخزين بقيه بيانات المستخدم في قاعده البيانات

//بعدها يتم عرض رساله للمستخدم انه قد تمت ارسا رساله في البريد فيجب عليه التاكد منها

        } else {
          Navigator.pop(context);
          showDialogMethod(context, "انشاء حساب", "فشلت عملية انشاء الحساب");
        }
      } on FirebaseAuthException catch (e) {
        //لاخفاء حوار الانتظار===
        Navigator.pop(context);
        if (e.code == 'weak-password') {
          showDialogMethod(context, "انشاء حساب", "كلمه سر ضعيفة");
        }
        if (e.code == 'email-already-in-use') {
          showDialogMethod(context, "انشاء حساب", "الايميل موجود مسبقا");
        }
      } catch (e) {
        print(e);
      }
    } else {
      showDialogMethod(context, " انشاء حساب", "إملء كل الحقول اعلاها");
    }
  }
}
