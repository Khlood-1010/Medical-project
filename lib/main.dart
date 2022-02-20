import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LuncherPage/LuncherPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'home pages/userHome.dart';

bool islogging;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  
  

  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogging = false;
  } else {
    islogging = true;
  }
  runApp(MyApp());
}

//-care of diabetes-------------------------------------
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'DroidKufi'),
      home: Directionality(textDirection: TextDirection.rtl, child: 
   // islogging==false?
    LuncherPage()
    //:
     // UserHome()
      ),
    );
  }
}
