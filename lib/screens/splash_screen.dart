import 'package:flutter/material.dart';
import '../constants.dart';
import 'welcome_screen.dart';
import 'dashboard.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/database/Student_DAO.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(0, 0, 0, 30),
              Color.fromRGBO(70, 10, 10, 10)
            ])),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 100),
                child: Image.asset(
                  'images/blue.png',
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Texts('Made with ❤ by the VITask Team', 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 2), () {
      navigateUser();
      //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('regNo');
    var password = prefs.getString('password');
    Map<String, dynamic> p;
    Map<String, dynamic> att;
    Map<String, dynamic> tt;
    Map<String, dynamic> m;
    Map<String, dynamic> ah;
    if (username != null && password != null) {
      p = (await StudentDao().getData(username + "-profile"));
      att = (await StudentDao().getData(username + "-attendance"));
      tt = (await StudentDao().getData(username + "-timeTable"));
      m = (await StudentDao().getData(username + "-marks"));
      ah = (await StudentDao().getData(username + "-acadHistory"));
      if (p != null && att != null && tt != null && m != null && ah != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    MenuDashboardPage(p, att, tt, m, ah, password)));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      }
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WelcomeScreen()));
    }
  }
}
