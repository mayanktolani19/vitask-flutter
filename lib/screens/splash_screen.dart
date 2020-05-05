import 'package:flutter/material.dart';
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
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/side.jpg"), fit: BoxFit.cover),
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
    var status = prefs.getString('regNo');
    Map<String, dynamic> p;
    Map<String, dynamic> att;
    Map<String, dynamic> tt;
    Map<String, dynamic> m;
    Map<String, dynamic> ah;
//    print(status);
    if (status != null) {
      p = (await StudentDao().getData(status + "-profile"));
      att = (await StudentDao().getData(status + "-attendance"));
      tt = (await StudentDao().getData(status + "-timeTable"));
      m = (await StudentDao().getData(status + "-marks"));
      ah = (await StudentDao().getData(status + "-acadHistory"));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  MenuDashboardPage(p, att, tt, m, ah)));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WelcomeScreen()));
    }
  }
}
