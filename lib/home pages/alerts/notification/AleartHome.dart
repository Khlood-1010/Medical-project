import 'package:flutter/material.dart';

import '../../../models.dart';
class AleartHome extends StatefulWidget {
  AleartHome({Key key}) : super(key: key);

  @override
  _AleartHomeState createState() => _AleartHomeState();
}

class _AleartHomeState extends State<AleartHome> {
  @override
  Widget build(BuildContext context) {
     var height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              //bacground image------------------------------
              containerWithImage(
                  context, height, "midical4.jpg", "تنبيهات بمواعيد الادوية"),
                  
              //fields----------------------------------------
             
                       
//-------------------------------------------------------------------------------------
                      
                    
             ] )) ));
  }
}
