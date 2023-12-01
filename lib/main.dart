import 'package:financialapp/auth_login_pages/home_page.dart';
import 'package:financialapp/tracker_pages/google_sheet_api.dart';
import 'package:financialapp/tracker_pages/tracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_login_pages/auth_page.dart';
import 'firebase_options.dart';
import 'package:dcdg/dcdg.dart';

//light cyan
//Color(0xFF0FF8FF)

//dark cyan
//Color(0xFF04B0EC)


//light purple
//Color(0xFFC201F2)

//dark purple
//Color(0xFF60019F)


//dark blue
//Color(0xFF04102A)

// a lighter than dark blue
//Color(0xFF04102A).withOpacity(0.9)

//background color
//Color(0xFF04102A)

//card color
//Color(0xFF213A71)


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GoogleSheetsApi().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
