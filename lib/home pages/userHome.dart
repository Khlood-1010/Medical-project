import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models.dart';
import 'Emergency/Emergency.dart';
import 'alerts/AleartHome.dart';
import 'meals/Meals.dart';
import 'sugerTest/SugerTest.dart';

String username = '';
String email = '';

class UserHome extends StatefulWidget {
  UserHome({Key key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  var user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection("user")
        .where("userID", isEqualTo: "$user")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          username = element.data()['name'];
          email = element.data()['Emile'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
//pages name-------------------------------------------
    List page = [SugerTest(), AleartHome(), Meals(), Emergence()];
//catogarys images-------------------------------------------
    List<String> image = [
      "lib/assist/suger.jpg",
      "lib/assist/midical4.jpg",
      "lib/assist/meals.jpg",
      "lib/assist/em.jpg"
    ];
//catogarys names-------------------------------------------
    List<String> cato_names = ["اختبار السكر", "تنبيهات", "الوجبات", "الطوارئ"];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
//user information--------------------------------------------------

          appBar: AppBar(
            centerTitle: true,
            title: Text("Care of Diabetes",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Quicksand")),
            elevation: 0,
            backgroundColor: appColor,
          ),
          drawer: drawer(context, username, email),
//main body--------------------------------------------------
          body: Container(
            height: height,
            width: width,
            color: Colors.blue[50],
            child: Stack(
              children: [
//image------------------------------------
                Container(
                  decoration: BoxDecoration(
                      color: appColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100))),
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  child: Lottie.asset("lib/lottie/health-care.json",
                      fit: BoxFit.contain),
                  height: height / 3,
                ),
//catogary-----------------------------------------

                Positioned(
                  top: height / 2.7,
                  bottom: height / 70,
                  right: 20,
                  left: 20,
                  child: GridView.builder(
                      itemCount: 4,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //عدد العناصر في كل صف
                          crossAxisSpacing: 15, // المسافات الراسية
                          childAspectRatio: 0.90, //حجم العناصر
                          mainAxisSpacing: 0 //المسافات الافقية

                          ),
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => page[i]));
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Container(
                                  height: 120,

                                  width: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(image[i]),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black54, BlendMode.darken),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                        )
                                      ],
                                      color: white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  //cato_image-------------------------
                                  child: Center(
                                    child: Text(cato_names[i],
                                        style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: white,
              )),
                                  ),
                                ),
                                //names-------------------------
                                // Container(
                                //   margin: EdgeInsets.only(top: 10, bottom: 10),
                                //   child:
                                // ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
