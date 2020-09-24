import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter/material.dart';
import 'package:vitask/api.dart';
import 'package:vitask/database/Student_DAO.dart';
import 'package:vitask/database/StudentModel.dart';
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
    Map<String, dynamic> attendanceData = await api
        .getAPIData('http://134.209.150.24/api/vtop/attendance', {"token": t});
    Map<String, dynamic> timeTableData = await api
        .getAPIData('http://134.209.150.24/api/vtop/timetable', {"token": t});
    Map<String, dynamic> marksData = await api
        .getAPIData('http://134.209.150.24/api/vtop/marks', {"token": t});
    Map<String, dynamic> acadHistoryData = await api
        .getAPIData('http://134.209.150.24/api/vtop/history', {"token": t});
    if (attendanceData != null &&
        timeTableData != null &&
        marksData != null &&
        acadHistoryData != null) {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(13, 40, 130, 100),
              Color.fromRGBO(5, 10, 40, 10)
            ])),
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
                  JumpingText('Fetching Your Data...'),
                ]),
          ),
        ),
      ),
    );
  }
}
