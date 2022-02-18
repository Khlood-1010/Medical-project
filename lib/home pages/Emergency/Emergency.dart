import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../models.dart';


class Emergence extends StatefulWidget {
  Emergence({Key key}) : super(key: key);

  @override
  _EmergenceState createState() => _EmergenceState();
}

class _EmergenceState extends State<Emergence> {
  var user;
  List phoneFromdb = [];
  var contriy, street, name, locality;
  String string = '';
  bool visable = false;
  TextEditingController helth = TextEditingController();

  //get urrent user
  getCurrentUser() {
    user = FirebaseAuth.instance.currentUser.uid;
    print("=======$user");
  }

  @override
  void initState() {
    super.initState();

    getPhoneNumber();
    getLocaion();
    _getLocationAddress(latitude, longtitude);
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

//text-------------------------------------------
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                      child: Text("  وصف الحالة الصحية (اختياري)")),
//Edit Field-------------------------------------------

                  Container(
                    height: height / 5,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                    // color: Colors.red,
                    child: TextField(
                      controller: helth,
                      maxLength: 20,
                      maxLines: 8,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 13),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          //prefixIcon: Icon(Icons.pin_drop_rounded,size:44),
                          labelText: "علي سبيل المثال هبوط في السكري",
                          contentPadding: EdgeInsets.all(10)),
                    ),
                  ),

//SEND BUTTOM-------------------------------------------

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
                           print(phoneFromdb[0]);
                          lodding(context, "جاري إرسال الموقع");
                          if (helth.text.isEmpty) {
                            _sendSMS(
                                "ان مرسل الرسالة مصاب بوعكة صحية الرجاء تتبع الموقع لاسعافه في اسرع وقت\nhttps://www.google.com/maps/search/?api=1&query=$latitude,$longtitude",
                                ["${phoneFromdb[0]}"]);
                          } else {
                           
                            _sendSMS(
                                "${helth.text}\nhttps://www.google.com/maps/search/?api=1&query=$latitude,$longtitude",
                                ["${phoneFromdb[0]}"]);
                          }
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
    String _result = await sendSMS(message: message, recipients: phone)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

//get location address-----------------------------------------------------------

  _getLocationAddress(lat, long) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, long);

    setState(() {
      name = placemark[0].name;
      street = placemark[0].street;
      string = "$name,$street";

      print(string);
    });
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
        });
      });
    });
  } //get
} //class
