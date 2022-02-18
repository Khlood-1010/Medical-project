import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'home pages/ConcatUs/ConcatUs.dart';
import 'home pages/Emergency/Emergency.dart';
import 'home pages/alerts/Aleart.dart';
import 'home pages/meals/Meals.dart';
import 'home pages/sugerTest/SugerTest.dart';
import 'home pages/userHome.dart';
import 'loging_singUp/Logging.dart';
import 'package:email_validator/email_validator.dart';

//-----------------------------------المتغيرات-------------------------------------------------

Color appColor = Colors.blue[500];
Color itemColor = Colors.blue[50];
Color iconColor = Colors.blue[900];
Color white = Colors.white;
Color black = Colors.black;
var latitude, longtitude;

//=====================================textfield========================================

//textField----------------------------------------------------------------------------
TextFormField textFromField(Widget icons, suffixIcon, String hitText,
    bool hintPass, TextEditingController mycontroller, myvali, fontSize) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,

    controller: mycontroller,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        labelStyle: TextStyle(color: Colors.black, fontSize: fontSize),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: icons,
        isDense: false,
        suffixIcon: suffixIcon,
        labelText: hitText,
        contentPadding: EdgeInsets.all(10)),
  );
}

//textField validate methot----------------------------------------------------------------------------

//التحقق من صحه الاسم المدخل
// ignore: missing_return
String validName(String value) {
  if (value.isEmpty) {
    return "املء الحقل اعلاه";
  }
}

//التحقق من صحه الايميل المدخل
// ignore: missing_return
String valedEmile(value) {
  if (value.trim().isEmpty) {
    return "املء الحقل اعلاه";
  }
  if (EmailValidator.validate(value.trim()) == false) {
    return "البريد الالكتروني غير صالح";
  }
}

//التحقق من صحه الرقم المدخل
// ignore: missing_return
String valedPhone(String value) {
  if (value.isEmpty) {
    return "املء الحقل اعلاه";
  }
  if (value.length < 10 || value.length > 10) {
    return 'رقم الهاتف يجب ان يكون 10 ارقام';
  }
  if (!value.startsWith('05')) {
    return 'يجب ان يبدا رقم الهاتف ب 05';
  }
}

//التحقق من صحه العنوان المدخل
// ignore: missing_return
String validLeAgWe(String value) {
  if (value.isEmpty) {
    return "املء الحقل اعلاه";
  }
}

//التحقق من صحه كلمه المرور المدخل
// ignore: missing_return
String validPassword(String value) {
  if (value.isEmpty) {
    return "املء الحقل اعلاه";
  }
}
//===============================================================================

//drawer------------------------------------------------------------------------------------
Drawer drawer(conext) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: appColor),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                "lib/assist/profile.jpg",
              ),
            ),
            accountName: Text("الاء خالد احمد"),
            accountEmail: Text("Alaa.dev90@gmail.com")),
        ListTile(
          title: Text("الصفحة الرئسية"),
          leading: Icon(Icons.home, color: iconColor),
          onTap: () {
            goToPage(conext, UserHome());
          },
        ),
        ListTile(
          title: Text("اختبار السكر"),
          leading: Icon(Icons.fact_check_outlined, color: iconColor),
          onTap: () {
            goToPage(conext, SugerTest());
          },
        ),
        ListTile(
          title: Text("تنبهات بمواعيد الادوية"),
          leading: Icon(Icons.timer, color: iconColor),
          onTap: () {
            goToPage(conext, Aleart());
          },
        ),
        ListTile(
          title: Text("الوجبات المقترحة"),
          leading: Icon(Icons.food_bank, color: iconColor),
          onTap: () {
            goToPage(conext, Meals());
          },
        ),
        ListTile(
          title: Text("الطوارئ"),
          leading: Icon(Icons.medical_services, color: iconColor),
          onTap: () {
            goToPage(conext, Emergence());
          },
        ),
        ListTile(
          title: Text("التواصل"),
          leading: Icon(Icons.contact_support_sharp, color: iconColor),
          onTap: () {
            goToPage(conext, ConcatUs());
          },
        ),
        ListTile(
          title: Text("تسجيل الخروج"),
          leading: Icon(Icons.logout, color: iconColor),
          onTap: () {
            showOptionDayloLogOut(conext, "تسجيل الخروج",
                "هل تريد تسجيل الخروج من التطبيق؟", Logging());
          },
        ),
      ],
    ),
  );
}

//custumer clipper for continer------------------------------------------------------------------------------------

class MyCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

//go to any page------------------------------------------------------------------------------------

void goToPage(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
}

//get Location method------------------------------------------------------------------------------------
getLocaion() async {
  dynamic currentLocation = LocationData;

  var location = new Location();
  var error;

  try {
    currentLocation = await location.getLocation();

    latitude = currentLocation.latitude;
    longtitude = currentLocation.longitude;
    print(latitude);
    print(longtitude);
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      error = 'Permission denied';
    }
    currentLocation = null;
  }
}

//page header------------------------------------------------------------------------------------
Container containerWithImage(context, height, imageName, String text) {
  return Container(
      child: Center(
          child: Text(text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: white,
              ))),
      height: height / 4,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assist/$imageName"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
          color: appColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))));
}

//Container method---------------------------------------------------------

Container continerShape(
    double paddingTop,
    double paddingLeft,
    double paddingRight,
    double height,
    double marginTop,
    double marginLeft,
    double marginRight,
    double marginButtom,
    color,
    double borderRadius,
    Widget child) {
  return Container(
    child: child,
    padding: EdgeInsets.only(
      top: paddingTop,
      left: paddingLeft,
      right: paddingRight,
    ),
    margin: EdgeInsets.only(
        top: marginTop,
        left: marginLeft,
        right: marginRight,
        bottom: marginButtom),
    height: height,
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 1,
          )
        ],
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
  );
}

//lodding------------------------------------------------------------------------------------
lodding(BuildContext context, String titel) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
              title: Center(child: Text(titel)),
              content: Container(
                  height: height / 4,
                  width: width,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            child: Lottie.asset("lib/lottie/waiting.json")),
                      ),
                    ],
                  )),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear))
              ]),
        );
      });
}

//================================Dialoge==============================================================

showDialogMethod(BuildContext context, String titel, String contant) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(
              titel,
              textDirection: TextDirection.rtl,
            ),
            content: Text(
              contant,
              textDirection: TextDirection.rtl,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear))
            ]);
      });
}

//-------------------------------------------------------------------------------
showOptionDayloLogOut(
    BuildContext context, String titel, String contant, page) {
  var width = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(titel, textDirection: TextDirection.rtl),
            content: Text(contant, textDirection: TextDirection.rtl),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.green,
                    child: Text("نعم"),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => page));
                    },
                  ),
                  SizedBox(
                    width: width / 3.5,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Text("لا"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ]);
      });
}

//--------------------------------------------------------------------------------
showOptionDaylog(BuildContext context, String titel, String contant, page) {
  var width = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(titel, textDirection: TextDirection.rtl),
            content: Text(contant, textDirection: TextDirection.rtl),
            actions: [
              Row(
                //mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    color: Colors.green,
                    child: Text("نعم"),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => page));
                    },
                  ),
                  SizedBox(
                    width: width / 3.5,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Text("لا"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ]);
      });
}

//-------------------------------------------------------------------------
showDialogs(BuildContext context, String titel, String body) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
              title: Center(child: Text(titel)),
              content: Container(
                  height: height / 4,
                  width: width,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            child: Lottie.asset("lib/lottie/waiting.json")),
                      ),
                      Container(child: Text(body)),
                    ],
                  )),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear))
              ]),
        );
      });
}

//================================uniekID==============================================================
int createUnidID() {
  return DateTime.now().millisecondsSinceEpoch.remainder(1000);
}
