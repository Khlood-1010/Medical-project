import 'package:flutter/material.dart';

import '../../models.dart';


class SugerTest extends StatefulWidget {
  SugerTest({Key key}) : super(key: key);

  @override
  _SugerTestState createState() => _SugerTestState();
}

class _SugerTestState extends State<SugerTest> {
  bool sugerPerText = true;
  bool sugerTrakText = false;
  bool showTime = false;
  var testToInt;

  var test, midicalTaype;
  TextEditingController sugerPersentg = TextEditingController();
  TextEditingController sugerTrakome = TextEditingController();
  GlobalKey<FormState> formstat = GlobalKey();

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
                  10,0,
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
                          width: double.infinity,
                          padding:
                              EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: DropdownButton<String>(
                            iconEnabledColor: iconColor,
                            iconSize: 30,
                            hint: Text(
                                "اختر نوع تحليل السكر                     "),
                            value: test,
                            items: <String>[
                              "فحص السكر التراكمي",
                              'بعد الاكل بساعتين',
                              'فحص الدم للصائم'
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
                                  case 'فحص الدم للصائم':
                                    {
                                      setState(() {
                                        sugerPerText = true;
                                        sugerTrakText = false;
                                        //showTime = false;
                                      });
                                    }
                                    break;
                                }
                              });
                            },
                          ),
                        ),
//وقت الاختبار-------------------------------------------------------------------------------------

                        // Visibility(
                        //   visible: showTime,
                        //   child: Container(
                        //     width: double.infinity,
                        //     padding:
                        //         EdgeInsets.only(top: 15, left: 15, right: 15),
                        //     child: DropdownButton<String>(
                        //       iconEnabledColor: iconColor,
                        //       iconSize: 30,
                        //       hint: Text(
                        //           "اختر نوع العلاج                            "),
                        //       value: midicalTaype,
                        //       items: <String>[' قبل الاكل', 'بعد الاكل']
                        //           .map((String value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: Center(child: Text(value)),
                        //         );
                        //       }).toList(),
                        //       onChanged: (vale) {
                        //         setState(() {
                        //           midicalTaype = vale;
                        //           print(midicalTaype);
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
// save buttom-------------------------------------------------------------------------------------

                        Container(
                            //color: Colors.red,
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
                                      sugerTrakome.clear();
                                      break;
                                    case 'بعد الاكل بساعتين':
                                      randoumTest(sugerPersentg.text);
                                      sugerPersentg.clear();
                                      break;
                                    case 'فحص الدم للصائم':
                                      siyamTest(sugerPersentg.text);
                                      sugerPersentg.clear();
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
    testToInt = num.parse(test);
    if (testToInt < 5.7) {
      showDialogMethod(context, "نتيجة الفحص",
          "انت غير مصاب بالسكر ومعدل السكر في الدم طبيعي");
    } else if (testToInt >= 5.7 && testToInt <= 6.4) {
      showDialogMethod(context, "نتيجة الفحص",
          " انت مهدد بشدة بالإصابة بمرض السكري ومعدل السكر في الدم اعلي من طبيعي");
    } else {
      showDialogMethod(context, "نتيجة الفحص",
          "انت مصاب بمرض السكر ومعدل السكر في الدم مرتفع");
    }
  }

//----------------------اظهار النتيجة في حاله الفحص بعد الاكل--------------------------------
  randoumTest(test) {
    testToInt = int.parse(test);
    if (testToInt <= 50) {
      showDialogMethod(context, "نتيجة الفحص", "لديك هبوط حاد في السكر");
    } else if (testToInt > 50 && testToInt <= 140) {
      showDialogMethod(context, "نتيجة الفحص",
          "انت غير مصاب بالسكر ومعدل السكر في الدم طبيعي");
    } else if (testToInt >= 140 && testToInt <= 199) {
      showDialogMethod(context, "نتيجة الفحص",
          " انت مهدد بشدة بالإصابة بمرض السكري ومعدل السكر في الدم اعلي من طبيعي");
    } else {
      showDialogMethod(context, "نتيجة الفحص",
          "انت مصاب بمرض السكر ومعدل السكر في الدم مرتفع");
    }
  }

// //-------------------------اظهار النتيجة في حاله الحامل -----------------------------
//   brignitTest(test) {
//     testToInt = int.parse(test);
//     if (testToInt < 100) {
//       print("انت غير مصاب بالسكر ومعدل السكر في الدم طبيعي");
//     } else if (testToInt > 100 && testToInt <= 125) {
//       print(
//           " انت مهدد بشدة بالإصابة بمرض السكري ومعدل السكر في الدم اعلي من طبيعي");
//     } else {
//       print("انت مصاب بمرض السكر ومعدل السكر في الدم مرتفع");
//     }
//   }

//------------------------اظهار النتيجة في حاله الفحص الصيامي------------------------------
  siyamTest(test) {
    //convert string to int value
    testToInt = int.parse(test);
    if (testToInt < 70) {
      showDialogMethod(context, "نتيجة الفحص", "لديك هبوط حاد في السكر");
    } else if (testToInt >= 70 && testToInt <= 100) {
      showDialogMethod(context, "نتيجة الفحص",
          "انت غير مصاب بالسكر ومعدل السكر في الدم طبيعي");
    } else if (testToInt > 100 && testToInt <= 125) {
      showDialogMethod(context, "نتيجة الفحص",
          " انت مهدد بشدة بالإصابة بمرض السكري ومعدل السكر في الدم اعلي من طبيعي");
    } else {
      showDialogMethod(context, "نتيجة الفحص",
          "انت مصاب بمرض السكر ومعدل السكر في الدم مرتفع");
    }
  }
}
