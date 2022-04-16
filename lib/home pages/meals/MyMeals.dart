import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models.dart';
import 'mealsDetials.dart';

class MyMeals extends StatefulWidget {
  MyMeals({Key key}) : super(key: key);

  @override
  State<MyMeals> createState() => _MyMealsState();
}

class _MyMealsState extends State<MyMeals> {
  var userId;
    @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
   
  }
  CollectionReference mealsCollection =
      FirebaseFirestore.instance.collection("MyMeals");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      stream: mealsCollection.where("UserId",isEqualTo:userId).snapshots(),
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
            itemCount: snapshat.data.docs.length,
            itemBuilder: (context, i) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      goToPage(
                          context,
                          MealsDetials(
                            mealsId: snapshat.data.docs[i].id,
                            mealsLenght: snapshat.data.docs[i]
                                .data()['Categories']
                                .length,
                            Categories:
                                snapshat.data.docs[i].data()['Categories'],
                            Calories: snapshat.data.docs[i].data()['Calories'],
                            fat: snapshat.data.docs[i].data()['fat'],
                            carbs: snapshat.data.docs[i].data()['carbs'],
                            Protein: snapshat.data.docs[i].data()['Protein'],
                          ));
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
                                          image: NetworkImage(snapshat
                                              .data.docs[i]
                                              .data()['image']),
                                          fit: BoxFit.cover))),
                            )),
                            Expanded(
//add to my meals-----------------------------------------------------------------------
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
//meals name-------------------------------------------------

                                    text(context, "وجبة رقم ${i + 1}", 13.5,
                                        black,
                                        fontWeight: FontWeight.bold),
                                    SizedBox(height: 10),
//meals name-------------------------------------------------
                                    //must add total Calories
                                    text(
                                        context,
                                        "السعرات الحرارية " +
                                            "${snapshat.data.docs[i].data()['Calories'][0]}",
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
        : Center(
            child: text(context, "لاتوجد وجبات مفضلة الي الان", 14,
                appColor));
  }

  Widget heder(String name) {
    return text(context, name, 9, appColor, fontWeight: FontWeight.w700);
  }
  //--------------------------------------------------

}
