import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical/home%20pages/userHome.dart';

import '../../models.dart';

class SugerTest extends StatefulWidget {
  SugerTest({Key key}) : super(key: key);

  @override
  _SugerTestState createState() => _SugerTestState();
}

class _SugerTestState extends State<SugerTest> {
  bool sugerPerText = true;
  bool sugerTrakText = false;

  var testToInt;
  var userId;
  var userEmail;
  String diabetesResult;

  var test, midicalTaype;
  TextEditingController sugerPersentg = TextEditingController();
  TextEditingController sugerTrakome = TextEditingController();
  GlobalKey<FormState> formstat = GlobalKey();

  getCurrentUser() {
    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;
    print("=======$userEmail");
    print("=======$userId");
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: appColor),
        drawer: drawer(context),
        body: Container(
          color: itemColor,
          child: ListView(
            children: [
              containerWithImage(context, height, "suger.jpg", "اختبار السكر"),
//text-------------------------------------------
              Container(
                  margin: EdgeInsets.only(top: 30, left: 20, right: 15),
                  child: Center(
                      child: Text("اعرف نتيجة فحصك الان",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                              fontSize: 18)))),

//---------------------------------------------------------
              continerShape(
                  40,
                  10,
                  10,
                  height * 0.45,
                  35,
                  10,
                  10,
                  0,
                  white,
                  10,
                  //child:
                  Form(
                    key: formstat,
                    child: Column(
                      children: [
//نسبه السكر--------------------------------------------------------------------------------
                        Visibility(
                          visible: sugerPerText,
                          child: textFromField(
                              Icon(Icons.style_rounded, color: iconColor),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, size: 0),
                                color: Colors.green[900],
                                onPressed: () {
                                  print("g");
                                },
                              ),
                              "أدخل نسبة السكر في الدم",
                              false,
                              sugerPersentg,
                              validLeAgWe,
                              12.0),
                        ),
                        SizedBox(height: 10),
//السكر التراكمي--------------------------------------------------------------------------------
                        Visibility(
                          visible: sugerTrakText,
                          child: textFromField(
                              Icon(Icons.opacity_sharp, color: iconColor),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  size: 0,
                                ),
                                color: Colors.green[900],
                                onPressed: () {
                                  print("g");
                                },
                              ),
                              " أدخل نسبة السكر التراكمي ",
                              false,
                              sugerTrakome,
                              validLeAgWe,
                              12.0),
                        ),
                        SizedBox(height: 10),
// وقت الاختبار--------------------------------------------------------------------------------
                        Container(
                          // color: Colors.red,
                          width: double.infinity,
                          padding: EdgeInsets.only(right: 5),
                          child: DropdownButton<String>(
                            iconEnabledColor: iconColor,
                            iconSize: 30,
                            hint: Text(
                                "اختر نوع تحليل السكر                     "),
                            value: test,
                            items: <String>[
                              "فحص السكر التراكمي",
                              'بعد الاكل بساعتين',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            }).toList(),
                            onChanged: (vale) {
                              setState(() {
                                test = vale;
                                switch (test) {
                                  case "فحص السكر التراكمي":
                                    {
                                      setState(() {
                                        sugerPerText = false;
                                        sugerTrakText = true;
                                        // showTime = false;
                                      });
                                    }
                                    break;
                                  case 'بعد الاكل بساعتين':
                                    {
                                      setState(() {
                                        sugerPerText = true;
                                        sugerTrakText = false;
                                        //showTime = true;
                                      });
                                    }

                                    break;
                                }
                              });
                            },
                          ),
                        ),

// save buttom-------------------------------------------------------------------------------------

                        Container(
                            width: double.infinity,
                            margin:
                                EdgeInsets.only(top: 10, right: 20, left: 20),
                            child: RaisedButton.icon(
                              color: appColor,
                              icon: Icon(Icons.book,
                                  size: 20, color: Colors.white),
                              label: Text("اظهار النتيجة",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: white)),
                              onPressed: () {
                                var formdata = formstat.currentState;
                                if (formdata.validate() == true) {
                                  switch (test) {
                                    case "فحص السكر التراكمي":
                                      trakomeTest(sugerTrakome.text);
                                      // sugerTrakome.clear();
                                      break;
                                    case 'بعد الاكل بساعتين':
                                      randoumTest(sugerPersentg.text);
                                      // sugerPersentg.clear();
                                      break;
                                  }
                                }
                              },
                            )),
//-------------------------------------------------------------------------------------
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

//--------------------------اظهار النتيجة في حاله الفحص التراكمي----------------------------
  trakomeTest(test) {
    testToInt = num.parse(test.trim());
    if (testToInt < 4) {
     setState(() {
        diabetesResult = "منخفض";
      });
      showOptionYesNo(context, "نتيجة الفحص",
          " لديك هبوط حاد في السكر " + addToDB, addSugerTestToDb);
    } else if (testToInt >= 4 && testToInt <= 6.4) {
       setState(() {
        diabetesResult = "طبيعي";
      });
      showDialogMethod(context, "نتيجة الفحص",
          " انت مهدد بشدة بالإصابة بمرض السكري ومعدل السكر في الدم اعلي من طبيعي");
    } else {
      setState(() {
        diabetesResult = "مرتفع";
      });
      showOptionYesNo(
          context,
          "نتيجة الفحص",
          " انت  مصاب بالسكر ومعدل السكر في الدم مرتفع" + addToDB,
          addSugerTestToDb);
    }
  }

//----------------------اظهار النتيجة في حاله الفحص بعد الاكل--------------------------------
  randoumTest(test) {
    testToInt = int.parse(test.trim());
    if (testToInt < 80) {
      setState(() {
        diabetesResult = "منخفض";
      });
      showOptionYesNo(context, "نتيجة الفحص",
          " لديك هبوط حاد في السكر " + addToDB, addSugerTestToDb);
    } else if (testToInt >= 80 && testToInt <= 130) {
      setState(() {
        diabetesResult = "طبيعي";
      });
      showOptionYesNo(
          context,
          "نتيجة الفحص",
          " معدل السكر في الدم طبيعي" + addToDB,
          addSugerTestToDb);
    } else {
      setState(() {
        diabetesResult = "مرتفع";
      });
      showOptionYesNo(
          context,
          "نتيجة الفحص",
          " معدل السكر في الدم مرتفع" + addToDB,
          addSugerTestToDb);
    }
  }

//-----------------------------------------------------------------------
  addSugerTestToDb() async {
    lodding(context, "");
    await FirebaseFirestore.instance.collection('SugarTable').add({
      "userID": userId,
      'Emile': userEmail,
      "Date of Test":
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "Time of Test": "${DateTime.now().hour} : ${DateTime.now().minute}",
      "Measure": sugerPerText ? sugerPersentg.text : sugerTrakome.text,
      "Diabetes type": sugerPerText ? "عشوائي" : "تراكمي",
      "diabetes result": diabetesResult
    })

        //التحقق ما اذا تمت العمليه بنجاح ام لا
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      showOptionDaylog(context, "اختبار السكر",
          "تمت العملية بنجاح هل تريد الذهاب الي الصفحة الرئيسية؟", UserHome());
    }).catchError((e) {
      Navigator.pop(context);
      showDialogMethod(context, "انشاء حساب", "حصلت مشكلة في قاعدة البيانات");
    });
  }
}
