import 'package:flutter/material.dart';

import '../../models.dart';
import 'Meals.dart';

class MealsDetials extends StatefulWidget {
  MealsDetials({Key key}) : super(key: key);

  @override
  State<MealsDetials> createState() => _MealsDetialsState();
}

class _MealsDetialsState extends State<MealsDetials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 10,
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    goToPage(context, Meals());
                  },
                  icon: Icon(Icons.arrow_forward))
            ],
            backgroundColor: Colors.black54,
            title: Text("تفاصيل الوجبة")),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
//------------------------------------------------------
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(2),
                  //padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: appColor,
                      border: Border.all(color: Colors.black54, width:1)),
                  child: Row(
                    children: [
                      Expanded(
                        child: text(context, "السعرات", 13, white),
                      ),
                      divider(color: itemColor,),
                      Expanded(
                        child: text(context, "الكربوهايدريت", 13, white),
                      ),
                      divider(color: itemColor,),
                      Expanded(
                        child: text(context, "الدهون", 13, white),
                      ),
                      divider(color: itemColor,),
                      Expanded(
                        child: text(context, "المكونات", 13, white),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 2)),
                  child: ListView.separated(
                      separatorBuilder: (context, i) {
                        return Divider(
                          color: Colors.grey[400],
                        );
                      },
                      itemCount:
                          5, //snapshat.data.docs[i].data()['ordersName'].length,
                      itemBuilder: (context, j) {
                        return Row(
                          children: [
                            Expanded(
                              child: text(
                                  context, "الشوفان الطازج والعنب", 14, black),
                            ),
                            divider(),
                            Expanded(
                              child: text(
                                  context, "الشوفان الطازج والعنب", 14, black),
                            ),
                            divider(),
                            Expanded(
                              child: text(
                                  context, "الشوفان الطازج والعنب", 14, black),
                            ),
                            divider(),
                            Expanded(
                              child: text(
                                  context, "الشوفان الطازج والعنب", 14, black),
                            )
                          ],
                        );
                      }),
                ),
              ),
//------------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: buttomText(
                        context, "اضافة الي وجباتي", 12.0, white, () {})),
              ),
            ],
          ),
        ));
  }
}
