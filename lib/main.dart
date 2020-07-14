import 'package:flutter/material.dart';
import 'package:vitask/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Vitask());

class Vitask extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    hi();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VITask',
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }

//  void hi() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    preferences.clear();
//  }
}
