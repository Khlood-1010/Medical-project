import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models.dart';
import '../userHome.dart';

class SugerTest extends StatefulWidget {
  SugerTest({Key key}) : super(key: key);

  @override
  _SugerTestState createState() => _SugerTestState();
}

class _SugerTestState extends State<SugerTest> {
  CollectionReference getReport =
      FirebaseFirestore.instance.collection('SugarTable');
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
        drawer: drawer(context, username, email),
        body: Container(
          color: itemColor,
          child: ListView(
            children: [
              containerWithImage(context, height, "suger.jpg", "اختبار السكر"),
//text-------------------------------------------
              Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 15),
                  child: Center(
                      child: Text("اعرف نتيجة فحصك الان",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                              fontSize: 18)))),

//---------------------------------------------------------
              continerShape(
                  30,
                  10,
                  10,
                  height * 0.45,
                  30,
                  10,
                  10,
                  10,
                  white,
                  10,
                  //child:
                  Form(
                    key: formstat,
                    child: SingleChildScrollView(
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
                                "أدخل نسبة السكر بعد الاكل",
                                false,
                                sugerPersentg,
                                validLeAgWe,
                                12.0,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              )),

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
                                " أدخل نسبة السكر قبل الاكل ",
                                false,
                                sugerTrakome,
                                validLeAgWe,
                                12.0,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              )),

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
                                "قبل الاكل",
                                'بعد الاكل',
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
                                    case "قبل الاكل":
                                      {
                                        setState(() {
                                          sugerPerText = false;
                                          sugerTrakText = true;
                                          // showTime = false;
                                        });
                                      }
                                      break;
                                    case 'بعد الاكل':
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
                                      case "قبل الاكل":
                                        randoumTest(sugerTrakome.text);
                                        // sugerTrakome.clear();
                                        break;
                                      case 'بعد الاكل':
                                        randoumTest(sugerPersentg.text);
                                        // sugerPersentg.clear();
                                        break;
                                    }
                                  }
                                },
                              )),
//-------------------------------------------------------------------------------------
                          Container(
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(top: 10, right: 20, left: 20),
                              child: RaisedButton.icon(
                                color: appColor,
                                icon: Icon(Icons.report,
                                    size: 25, color: Colors.white),
                                label: Text("تقارير اختبار السكر",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: white)),
                                onPressed: () {
                                  showReports();
                                },
                              )),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  randoumTest(test) {
    testToInt = int.parse(test.trim());
    if (testToInt < 80) {
      setState(() {
        diabetesResult = "منخفض";
      });
      showOptionYesNo(context, "نتيجة الفحص", " لديك هبوط  في السكر " + addToDB,
          addSugerTestToDb);
    } else if (testToInt >= 80 && testToInt <= 130) {
      setState(() {
        diabetesResult = "طبيعي";
      });
      showOptionYesNo(
          context,
          "نتيجة الفحص",
          "انت غير مصاب بالسكر ومعدل السكر في الدم طبيعي " + addToDB,
          addSugerTestToDb);
    } else {
      setState(() {
        diabetesResult = "مرتفع";
      });
      showOptionYesNo(
          context,
          "نتيجة الفحص",
          "انت  مصاب بالسكر ومعدل السكر في الدم مرتفع " + addToDB,
          addSugerTestToDb);
    }
  }

//-----------------------------------------------------------------------
  addSugerTestToDb() async {
    lodding(context, "");
    await FirebaseFirestore.instance.collection('SugarTable').add({
      "userID": userId,
      "createdOn": FieldValue.serverTimestamp(),
      'Emile': userEmail,
      "Date of Test":
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "Time of Test": "${DateTime.now().hour} : ${DateTime.now().minute}",
      "Measure": sugerPerText ? sugerPersentg.text : sugerTrakome.text,
      "Diabetes type": sugerPerText ? "بعد الاكل" : "قبل الاكل",
      "diabetes result": diabetesResult,
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

  showReports() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: AlertDialog(
              titlePadding: EdgeInsets.zero,
                title: Container(
                  height: 60,
                  color:appColor,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "الفحوصات السابقة",
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                content: SizedBox(
                    child: StreamBuilder(
                  stream: getReport.orderBy('createdOn', descending: true).where( "userID",isEqualTo: userId,).snapshots(),
                  builder: (context, AsyncSnapshot snapshots) {
                    if (snapshots.hasData) {
                      return snapshots.data.docs.length > 0? 
                      ListView.builder(
                        itemCount:snapshots.data.docs.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text("${snapshots.data.docs[i].data()['Date of Test']}, ${snapshots.data.docs[i].data()['Time of Test']}"),
                            subtitle: Text("${snapshots.data.docs[i].data()['Measure']}"),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: appColor,
                              child: Center(
                                child: text(context, "${snapshots.data.docs[i].data()['diabetes result']}", 12, white),
                              ),
                            ),
                          );
                        },
                      ):Center(child:text(context, "لاتوجد فحوصات سابقة", 15, black));
                    } return Center(child: CircularProgressIndicator());
                  },
                )),
                actions: [
                  Center(
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.clear)),
                  )
                ]),
          );
        });
  }
}
