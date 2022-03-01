import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models.dart';
import 'Emergency/Emergency.dart';
import 'alerts/notification/AleartHome.dart';
import 'meals/Meals.dart';
import 'sugerTest/SugerTest.dart';

class UserHome extends StatefulWidget {
  UserHome({Key key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
//pages name-------------------------------------------
    List page = [SugerTest(), AleartHome(), Meals(), Emergence()];
//catogarys images-------------------------------------------
    List<String> image = [
      "lib/lottie/blood-test.json",
      "lib/lottie/stopwatch.json",
      "lib/lottie/healthy-breaksfast.json",
      "lib/lottie/emergency-call.json"
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
          drawer: drawer(context),
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
                          crossAxisSpacing: 20, // المسافات الراسية
                          childAspectRatio: 0.70, //حجم العناصر
                          mainAxisSpacing: 2 //المسافات الافقية

                          ),
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                           
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => page[i]));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        )
                                      ],
                                      color: white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  //cato_image-------------------------

                                  child: Lottie.asset(image[i],
                                      fit: BoxFit.contain),
                                ),
                                //names-------------------------
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(cato_names[i],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
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
