import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../models.dart';
import '../userHome.dart';

class Emergence extends StatefulWidget {
  Emergence({Key key}) : super(key: key);

  @override
  _EmergenceState createState() => _EmergenceState();
}

class _EmergenceState extends State<Emergence> {
  TextEditingController phone = TextEditingController();
  var user;
  var docId;
  List phoneFromdb = [];
  var contriy, street, name, locality;
  String string = '';
  bool visable = false;
  TextEditingController helth = TextEditingController();
  GlobalKey<FormState> formstat =GlobalKey();

  //get urrent user
  getCurrentUser() {
    user = FirebaseAuth.instance.currentUser.uid;
    print("=======$user");
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getPhoneNumber();
      getLocaion();
      _getLocationAddress(latitude, longtitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(phoneFromdb);
    var height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: appColor),
        drawer: drawer(context, username, email),
        body: Container(
            color: itemColor,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//text descraption-------------------------------------------
                  containerWithImage(context, height, "em.jpg", "طوارئ"),
//current location-------------------------------------------
                  //
                  Container(
                      //color: Colors.red,
                      margin: EdgeInsets.only(top: 40, left: 20, right: 12),
                      child: Row(
                        children: [
                          Icon(Icons.pin_drop_rounded, color: Colors.red),
                          SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  visable = true;
                                  getLocaion();
                                  _getLocationAddress(latitude, longtitude);
                                });
                              },
                              child: Text("اظهار الموقع الحالي")),
                        ],
                      )),
//-------------------------------------------------------------------------
                  Visibility(
                    visible: visable,
                    child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ],
                          color: appColor,
                        ),
                        margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                        child: Text(string,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: white))),
                  ),

                  Container(
                      //color: Colors.red,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                      child: RaisedButton.icon(
                        color: appColor,
                        icon: Icon(Icons.pin_drop_rounded,
                            size: 0, color: Colors.black),
                        label: Text("إرسال",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: white)),
                        onPressed: () {
                          lodding(context, "جاري إرسال الموقع");

                          _sendSMS(
                              "ان مرسل الرسالة مصاب بوعكة صحية الرجاء تتبع الموقع لاسعافه في اسرع وقت\nhttps://www.google.com/maps/search/?api=1&query=$latitude,$longtitude",
                              ["${phoneFromdb[0]}"]);
                        },
                      )),

                  SizedBox(height: 10),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                      child: RaisedButton.icon(
                        color: appColor,
                        icon: Icon(Icons.pin_drop_rounded,
                            size: 0, color: Colors.black),
                        label: Text("تعديل رقم الطوارئ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: white)),
                        onPressed: () {
                          changPhone();
                        },
                      )),
                ],
              ),
            )),
      ),
    );
  }

//send messege to phone number-----------------------------------------------------------

  _sendSMS(String message, List<String> phone) async {
    try {
      String _result = await sendSMS(message: message, recipients: phone)
          .catchError((onError) {
        print(onError);
      });
      print(_result);
    } catch (e) {}
  }

//get location address-----------------------------------------------------------

  _getLocationAddress(lat, long) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(lat, long);

      setState(() {
        name = placemark[0].subLocality;
        street = placemark[0].thoroughfare;
        contriy = placemark[0].country;
        locality = placemark[0].locality;
        string = "$contriy,$locality,$name,$street";

        print(string);
      });
    } catch (e) {}
  }

//get phone from db-----------------------------------------------------------
  getPhoneNumber() async {
    getCurrentUser();
    FirebaseFirestore.instance
        .collection("user")
        .where("userID", isEqualTo: "$user")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          phoneFromdb.add(element.data()['phone']);
          phone.text = '${phoneFromdb[0]}';
          docId = element.id;
        });
      });
    });
  }

  changPhone() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
                title: Text(
                  "تغير رقم الطوارئ",
                  textDirection: TextDirection.rtl,
                ),
                content: Form(
                  key:formstat,
                  child: textFromField(
                      Icon(Icons.call, color: Colors.redAccent[700]),
                      Icon(Icons.add, size: 0),
                      "الرقم",
                      false,
                      phone,
                      valedPhone,
                      14.0,keyboardType:TextInputType.phone  ),
                ),
                actions: [
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            lodding(context,   "تغير رقم الطوارئ",);
                            if (formstat.currentState.validate()) {
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc("$docId")
                                  .update({
                                'phone': phone.text,
                              }).then((value) {
                                Navigator.pop(context);
                                showOptionDaylog(
                                    context,
                                     "تغير رقم الطوارئ",
                                    "تمت العملية بنجاح هل تريد الانتقال الي الصفحة الرئيسية؟",
                                    UserHome());
                              });
                            }
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear)),
                    ],
                  ))
                ]),
          );
        });
  } //get
} //class
