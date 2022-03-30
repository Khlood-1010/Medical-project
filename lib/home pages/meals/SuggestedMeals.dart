import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical/models.dart';

import 'mealsDetials.dart';

class SuggestedMeals extends StatefulWidget {
  SuggestedMeals({Key key}) : super(key: key);

  @override
  State<SuggestedMeals> createState() => _SuggestedMealsState();
}

class _SuggestedMealsState extends State<SuggestedMeals> {
  List diabetesTherpy = [];
  var collection;
  @override
  void initState() {
    super.initState();
    getType();
  }

  CollectionReference mealsCollection =
      FirebaseFirestore.instance.collection("LowSugar");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: appColor),
        drawer: drawer(context),
        body: Container(
            // color: Colors.red,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: mealsCollection.snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshat) {
                        if (snapshat.hasError) {
                          return Text("Connection error");
                        }
                        if (snapshat.hasData) {
                          return getMeals(context, snapshat);
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                )),
              ],
            )));
  }

  Widget getMeals(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length > 0
        ? ListView.builder(
              itemCount: 4,
              itemBuilder: (context, i) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        goToPage(context, MealsDetials());
                      },
                      child: Card(
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
//meals image-------------------------------------------------
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'lib/assist/midical4.jpg'),
                                            fit: BoxFit.cover))),
                              )),
                              Expanded(
 //-----------------------------------------------------------------------
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
 //meals name-------------------------------------------------
                    
                                      text(context, "وجبة رقم $i", 13.5,
                                          black,
                                          fontWeight: FontWeight.bold),
                                          SizedBox(height: 10),
 //meals name-------------------------------------------------
                    
                                      text(
                                          context,
                                          "السعرات الحرارية" + " 120Kls",
                                          14,
                                          black),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              },
        )
        : Text("no daaaaaaata");
  }

  Widget heder(String name) {
    return text(context, name, 9, appColor, fontWeight: FontWeight.w700);
  }
  //--------------------------------------------------

  Widget getStudentOrders(snapshat, i) {
    return Expanded(
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.grey[400],
            );
          },
          itemCount:  snapshat.data.docs[i].data()['Categories'].length,
          itemBuilder: (context, j) {
            return Row(
              children: [
                Expanded(
                  child: text(context,"${snapshat.data.docs[i].data()['Categories'][j]}", 12, black,
                      fontWeight: FontWeight.w700),
                ),
                divider(),
                Expanded(
                  child: text(context,"${snapshat.data.docs[i].data()['Calories'][j]}", 12, black,
                      fontWeight: FontWeight.w700),
                ),
                divider(),
                Expanded(
                  child: text(context, "${snapshat.data.docs[i].data()['fat'][j]}", 12, black,
                      fontWeight: FontWeight.w700),
                ),
                divider(),
                Expanded(
                  child: text(context, "${snapshat.data.docs[i].data()['carbs'][j]}", 12, black,
                      fontWeight: FontWeight.w700),
                ),
                divider(),
                Expanded(
                  child: text(context, "${snapshat.data.docs[i].data()['Protein'][j]}", 12, black,
                      fontWeight: FontWeight.w700),
                ),
               
              ],
            );
          }),
    );
    //----------------------------------------------------------------------------
  }

  getType() async {
    await FirebaseFirestore.instance
        .collection("SugarTable")
        .orderBy('diabetes Therpy', descending: true)
        .limitToLast(1)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          diabetesTherpy.add(element.data()['diabetes Therpy']);
        });
      });
      if (diabetesTherpy == "مرتفع") {
        setState(() {
          collection = "HighSugar";
        });
      } else if (diabetesTherpy == "منخفض") {
        setState(() {
          collection = "LowSugar";
        });
      } else if (diabetesTherpy == "طبيعي") {
        setState(() {
          collection = "NormalSugar";
        });
      } else {
        setState(() {
          collection = null;
        });
      }
      print(collection);
      print("=========================");
    });
  }
}
