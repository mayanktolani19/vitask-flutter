import 'dart:async';

import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter/material.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/Widgets/show_toast.dart';
import 'package:vitask/api.dart';
import 'package:vitask/database/Student_DAO.dart';
import 'package:vitask/database/StudentModel.dart';
import 'package:vitask/functions/test_internet.dart';
import 'dashboard.dart';
import 'welcome_screen.dart';

class SplashScreen2 extends StatefulWidget {
  SplashScreen2(this.password, this.profileData);
  final String password;
  final Map<String, dynamic> profileData;
  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    API api = API();
    String t = widget.profileData['APItoken'].toString();
    String u = widget.profileData['RegNo'].toString();
    print("Start fetching");
    bool internet = await testInternet();
    if (internet) {
      Map<String, dynamic> attendanceData = {};
      try {
        attendanceData = await api.getAPIData(
            'http://134.209.150.24/api/vtop/attendance',
            {"token": t}).timeout(Duration(seconds: 8));
        print("Attendance");
      } on TimeoutException catch (_) {
        showToast('Something went wrong, please try again later', Colors.red);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      } catch (e) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      }
      Map<String, dynamic> timeTableData = {};
      try {
        timeTableData = await api.getAPIData(
            'http://134.209.150.24/api/vtop/timetable',
            {"token": t}).timeout(Duration(seconds: 8));
        print("Time table");
      } on TimeoutException catch (_) {
        showToast('Something went wrong, please try again later', Colors.red);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      } catch (e) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      }
      Map<String, dynamic> marksData = {};
      try {
        marksData = await api.getAPIData('http://134.209.150.24/api/vtop/marks',
            {"token": t}).timeout(Duration(seconds: 8));
        print("Marks");
      } on TimeoutException catch (_) {
        showToast('Something went wrong, please try again later', Colors.red);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      } catch (e) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      }
      Map<String, dynamic> acadHistoryData = {};
      try {
        acadHistoryData = await api.getAPIData(
            'http://134.209.150.24/api/vtop/history',
            {"token": t}).timeout(Duration(seconds: 8));
        print("History");
      } on TimeoutException catch (_) {
        showToast('Something went wrong, please try again later', Colors.red);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      } catch (e) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      }
      if ((attendanceData.isNotEmpty &&
              timeTableData.isNotEmpty &&
              marksData.isNotEmpty &&
              acadHistoryData.isNotEmpty) &&
          (acadHistoryData != null &&
              marksData != null &&
              timeTableData != null &&
              attendanceData != null)) {
        Student student = Student(
            profileKey: (u + "-profile"),
            profile: widget.profileData,
            attendanceKey: (u + "-attendance"),
            attendance: attendanceData,
            timeTableKey: (u + "-timeTable"),
            timeTable: timeTableData,
            marksKey: (u + "-marks"),
            marks: marksData,
            acadHistoryKey: (u + "-acadHistory"),
            acadHistory: acadHistoryData);
        StudentDao().deleteStudent(student);
        StudentDao().insertStudent(student);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MenuDashboardPage(
                    widget.profileData,
                    attendanceData,
                    timeTableData,
                    marksData,
                    acadHistoryData,
                    widget.password)));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
      }
    } else {
      showToast('Connection failed', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(gradient: gradient()),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GlowingProgressIndicator(
                    child: Container(
                      child: Image.asset('images/blue.png'),
                      height: 60.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  JumpingText('Fetching Your Data....'),
                ]),
          ),
        ),
      ),
    );
  }
}
