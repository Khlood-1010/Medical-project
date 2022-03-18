import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuggestedMeals extends StatefulWidget {
  SuggestedMeals({Key key}) : super(key: key);

  @override
  State<SuggestedMeals> createState() => _SuggestedMealsState();
}

class _SuggestedMealsState extends State<SuggestedMeals> {
  CollectionReference mealsCollection =
      FirebaseFirestore.instance.collection("NormalSugar");
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
                  child: FutureBuilder(
                      future: mealsCollection.get(),
                      builder: (BuildContext context, AsyncSnapshot snapshat) {
                        if (snapshat.hasError) {
                          print("ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRO");
                        }
                        if (snapshat.hasData) {
                          print(snapshat.data.docs.length);
                          return ListView.builder(
                              itemCount: 7,
                              itemBuilder: (context, i) {
                                print(snapshat.data.docs.length);
                                return Expanded(
                                    child: Text("cccccccc"));
                                      
                              });
                        }
                        // }  if (snapshat.hasData==null) {
                        //   print("NO DAAAAAAAAAAAAAAAAAAAATA FOUND");
                        // }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                )),
              ],
            )));
  }
}
