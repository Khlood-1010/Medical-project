import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models.dart';
import 'MyMeals.dart';
import 'mealsDetials.dart';

class SuggestedMeals extends StatefulWidget {
  SuggestedMeals({Key key}) : super(key: key);

  @override
  State<SuggestedMeals> createState() => _SuggestedMealsState();
}

class _SuggestedMealsState extends State<SuggestedMeals> {
  List diabetesTherpy = [];
  var collection;
  var userId;
  bool selectMeals = false;
  IconData addMeals = Icons.bookmark_border;
  IconData NotAddMeals = Icons.bookmark;
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
    getType();
  }

  CollectionReference mealsCollection ;
     
  @override
  Widget build(BuildContext context) {
    print(collection);
     mealsCollection =FirebaseFirestore.instance.collection("$collection");
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
                  child:collection==null?
                  Center(child: text(context, "لمن تظهر الوجبات الا بعد اختبار السكر", 14, appColor)): 
                  StreamBuilder(
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
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: IconButton(
                                          onPressed: () {
                                            addToMyMeals(
                                                mealsId:
                                                    snapshat.data.docs[i].id,
                                                mealsLenght: snapshat
                                                    .data.docs[i]
                                                    .data()['Categories']
                                                    .length,
                                                Categories: snapshat
                                                    .data.docs[i]
                                                    .data()['Categories'],
                                                Calories: snapshat.data.docs[i]
                                                    .data()['Calories'],
                                                fat: snapshat.data.docs[i]
                                                    .data()['fat'],
                                                carbs: snapshat.data.docs[i]
                                                    .data()['carbs'],
                                                Protein: snapshat.data.docs[i]
                                                    .data()['Protein'],
                                                image: snapshat.data.docs[i]
                                                    .data()['image']);
                                            setState(() {
                                              selectMeals = !selectMeals;
                                            });
                                          },
                                          icon: Icon(
                                            selectMeals
                                                ? NotAddMeals
                                                : addMeals,
                                            color: appColor,
                                          )),
                                    ),
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
        : Text("لاتوجد بيانات لعرضها");
  }

  Widget heder(String name) {
    return text(context, name, 9, appColor, fontWeight: FontWeight.w700);
  }
  //--------------------------------------------------

  getType() async {
    try {
      await FirebaseFirestore.instance
          .collection("SugarTable")
          .orderBy('createdOn', descending: true)
          .limit(1)
          .where("userID", isEqualTo: userId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            diabetesTherpy.add(element.data()['diabetes result']);
          });
          print(diabetesTherpy);
        });
        if (diabetesTherpy[0] == "مرتفع") {
          setState(() {
            collection = "HighSugar";
          });
        } else if (diabetesTherpy[0] == "منخفض") {
          setState(() {
            collection = "LowSugar";
          });
        } else if (diabetesTherpy[0] == "طبيعي") {
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
    } catch (e) {
      setState(() {
        collection = null;
      });
      print(collection);
    }
  }

  void addToMyMeals(
      {image,
      mealsId,
      mealsLenght,
      Categories,
      Calories,
      fat,
      carbs,
      Protein}) {
    FirebaseFirestore.instance.collection("MyMeals").add({
      "UserId": userId,
      "Categories": Categories,
      'fat': fat,
      'mealsLenght': mealsLenght,
      'Calories': Calories,
      'carbs': carbs,
      'Protein': Protein,
      'image': image
    }).then((value) {
      Navigator.pop(context);
      showOptionDaylog(
          context,
          "افة منبهه",
          "تمت اضافة الوجبة الي قائمة وجباتك المفضلة, هل تريد الانتقال الي صفحة وجباتي؟",
          MyMeals());
      //ارجاع الحقول فارغه
    });
  }
}
