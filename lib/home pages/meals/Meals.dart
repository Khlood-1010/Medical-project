import 'package:flutter/material.dart';

import '../../models.dart';
import 'MyMeals.dart';
import 'SuggestedMeals.dart';

class Meals extends StatefulWidget {
  Meals({Key key}) : super(key: key);

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  int _selectedIndex = 0;
  final List page = [
    SuggestedMeals(),
    MyMeals(),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          
          body: page[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 14,
            elevation: 4,
            selectedItemColor: white,
            unselectedItemColor: itemColor,
            unselectedFontSize: 10,
            currentIndex: _selectedIndex,
            backgroundColor: appColor,
            onTap: onTabTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.table_chart_outlined),
                label: "الوجبات المقترحة",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank),
                label: "وجباتي",
              ),
            ],
          ),

//              Container(
//                 color: itemColor,
//                 child: ListView(children: [
//                   containerWithImage(context, height, "meals.jpg", "الوجبات"),
// //buttom-------------------------------------------
//                 ])
// )
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
