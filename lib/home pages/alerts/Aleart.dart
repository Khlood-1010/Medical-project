import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models.dart';
import 'notification/AleartHome.dart';

class Aleart extends StatefulWidget {
  Aleart({Key key}) : super(key: key);

  @override
  _AleartState createState() => _AleartState();
}

class _AleartState extends State<Aleart> {
  TextEditingController midicalName = TextEditingController();
  TextEditingController midicalTime = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  GlobalKey<FormState> formstat = GlobalKey();
  String time = "";
  var star, user, repet, type;
  var notficationId = createUnidID();

//get urrent user
  getCurrentUser() {
    user = FirebaseAuth.instance.currentUser.uid;
    print("=======$user");
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
        appBar: AppBar(
            elevation: 10,
            centerTitle: true,
            backgroundColor: Colors.black54,
            title: Text("اضافة تنبيه")),
        body: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assist/midical4.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
          child: continerShape(
              40,
              10,
              10,
              height * 0.55,
              70,
              10,
              10,
              80,
              white,
              10,
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formstat,
                child: Column(
                  children: [
//name--------------------------------------------------------------------------------
                    textFromField(
                        Icon(Icons.medical_services_rounded, color: iconColor),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye, size: 0),
                          color: Colors.green[900],
                          onPressed: () {
                            print("g");
                          },
                        ),
                        "أدخل اسم الدواء",
                        false,
                        midicalName,
                        validLeAgWe,
                        12.0),
                    SizedBox(height: 10),

// time--------------------------------------------------------------------------------
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.alarm_outlined, color: iconColor),
                            onPressed: () {
                              _selectTime(context);
                            }),
                        Text(
                          " موعد الدواء                      ",
                          style: TextStyle(fontSize: 13),
                        ),
                        Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              "$time",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: iconColor),
                            )),
                      ],
                    ),

                    SizedBox(height: 10),
//repet--------------------------------------------------------------------------------
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.repeat_rounded, color: iconColor),
                            onPressed: () {}),
                        Text(
                          "تكرار التنبيه ",
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(width: 100),
                        Container(
                          child: DropdownButton<String>(
                            iconEnabledColor: iconColor,
                            iconSize: 30,
                            hint: Text("تنبيه"),
                            value: repet,
                            items: <String>[
                              "نعم",
                              "لا",
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            }).toList(),
                            onChanged: (vale) {
                              setState(() {
                                repet = vale;
                                print(repet);
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
//type--------------------------------------------------------------------------------
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.medical_services_outlined,
                                color: iconColor),
                            onPressed: () {}),
                        Text(
                          "نوع الدواء  ",
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(width: 100),
                        Container(
                          child: DropdownButton<String>(
                            iconEnabledColor: iconColor,
                            iconSize: 30,
                            hint: Text("النوع"),
                            value: type,
                            items: <String>[
                              "حقن",
                              "حبوب",
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            }).toList(),
                            onChanged: (vale) {
                              setState(() {
                                type = vale;
                                print(type);
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

// save buttom-------------------------------------------------------------------------------------

                    Container(
                        //color: Colors.red,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                        child: RaisedButton.icon(
                          color: appColor,
                          icon: Icon(Icons.alarm_on_outlined,
                              size: 20, color: Colors.white),
                          label: Text("اضافة منبهه",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: white)),
                          onPressed: () {
                            var formdata = formstat.currentState;
                            if (formdata.validate() == true &&
                                time.isNotEmpty &&
                                repet != null &&
                                type != null) {
                              lodding(context, " اضافة منبهه");

                              FirebaseFirestore.instance
                                  .collection("medical")
                                  .add({
                                "UserId": user,
                                "medicalName": midicalName.text,
                                "medicalTime": time,
                                "repet": repet,
                                "type": type,
                                "hours": selectedTime.hour,
                                "mint": selectedTime.minute,
                                "notificaton_id": notficationId
                              }).then((value) {
                                Navigator.pop(context);
                                showOptionDaylog(
                                    context,
                                    "  اضافة منبهه",
                                    "تمت العملية بنجاح هل تريد الانتقال الي الصفحة الرئيسية؟",
                                    AleartHome());
                                //ارجاع الحقول فارغه
                              });
                            } else {
                              showDialogMethod(context, "التنبيهات",
                                  "عليك التاكد من ملء جميع الحقول");
                            }
                          },
                        )),
//-------------------------------------------------------------------------------------
                  ],
                ),
              )),
        ),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        time = get12TimeZome(selectedTime);
        if (selectedTime.hour == 0) {
          star = ((selectedTime.hour * 60) + selectedTime.minute);
        } else if (selectedTime.hour == 12) {
          star = ((12 * 60) + selectedTime.minute);
        } else {
          star = ((selectedTime.hour * 60) + selectedTime.minute);
        }
      });
    }
  }

  String get12TimeZome(TimeOfDay time) {
    if (time.hour == 0) {
      if (time.minute.toString().length < 2) {
        return "12: 0${time.minute} AM";
      } else {
        return "12: ${time.minute} AM";
      }
    }

    if (time.hour == 12) {
      if (time.minute.toString().length < 2) {
        return "12: 0${time.minute} PM";
      } else {
        return "12: ${time.minute} PM";
      }
    }

    if (time.hour > 12) {
      if (time.minute.toString().length < 2) {
        return "${time.hour - 12}: 0${time.minute} PM";
      } else
        return "${time.hour - 12}: ${time.minute} PM";
    }

    if (time.hour < 12) {
      if (time.minute.toString().length < 2) {
        return "${time.hour}: 0${time.minute} AM";
      } else
        return "${time.hour}: ${time.minute} AM";
    }
  }
}
