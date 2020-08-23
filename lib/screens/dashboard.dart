import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitask/functions/calculate_attendance.dart';
import 'package:vitask/screens/attendance.dart';
import 'package:vitask/screens/gpa_calculator.dart';
import 'package:vitask/screens/timetable.dart';
import 'package:vitask/screens/marks.dart';
import 'package:vitask/screens/acadhistory.dart';
import 'welcome_screen.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:vitask/constants.dart';
import 'moodle_login.dart';
import 'profile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/api.dart';
import 'package:vitask/database/StudentModel.dart';
import 'package:vitask/database/Student_DAO.dart';
import 'moodle.dart';
import 'package:vitask/database/Moodle_DAO.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';
import 'bunk_meter.dart';

class MenuDashboardPage extends StatefulWidget {
  MenuDashboardPage(
    this.profileData,
    this.attendanceData,
    this.timeTableData,
    this.marksData,
    this.acadHistoryData,
    this.password,
  );
  Map<String, dynamic> profileData;
  Map<String, dynamic> attendanceData;
  Map<String, dynamic> timeTableData;
  Map<String, dynamic> marksData;
  Map<String, dynamic> acadHistoryData;
  String password;
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

GlobalWidget k = GlobalWidget();

class _MenuDashboardPageState extends State<MenuDashboardPage> {
  Map<String, dynamic> nextMarks;
  Map<String, dynamic> nextAttendance;
  String avgAttendance, updatedText;
  Map<String, String> attDetails = {};
  Map<String, double> pie = {};
  List<String> a, days, hours;
  List<dynamic> tt, tt1, attKeys, updatedOn;
  List<DateTime> time, timeNotifications;
  var now;
  int count, h, g, theory, labs;
  bool refresh = false;
  var regNo, token, pass;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    if (widget.profileData != null &&
        widget.acadHistoryData != null &&
        widget.marksData != null &&
        widget.timeTableData != null &&
        widget.attendanceData != null) print("YESSS");
    getAttendance();
    getTimeTable();
    count = 0;
    h = 1;
    g = 1;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    refreshData();
    super.initState();
  }

  void getAttendance() async {
    attKeys = widget.attendanceData["attendance"].keys.toList();
    CalculateAttendance cal =
        CalculateAttendance(widget.attendanceData, widget.profileData["RegNo"]);
    setState(() {
      updatedText = "";
      updatedOn = widget.attendanceData['attendance'][attKeys[0]]['updatedOn']
          .split(' ');
      for (int xy = 0; xy < updatedOn.length - 1; xy++)
        updatedText += (updatedOn[xy] + " ");
      a = cal.attendanceDetails();
      attDetails["Total"] = a[0];
      attDetails["Attended"] = a[1];
      attDetails["Percentage"] = a[2];
      pie["Present"] = double.parse(a[2]);
      pie["Absent"] = 100 - double.parse(a[2]);
    });
  }

  void setValue() {
    h = 1;
  }

  void getSlots() {
    if (now.weekday < 7) {
      labs = 0;
      theory = 0;
      for (var j = 0;
          j < widget.timeTableData["timetable"][days[now.weekday - 1]].length;
          j++) {
        tt1.add({"startTime": "xx"});
        if (tt[j]["slot"].contains("L"))
          labs++;
        else
          theory++;
      }
      labs = labs ~/ 2;
    }
  }

  void getTimeTable() {
    days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    hours = ["0", "13", "14", "15", "16", "17", "18", "19"];
    now = DateTime.now();
    tt1 = [];
    timeNotifications = [];
    if (now.weekday < 7) {
      tt = widget.timeTableData["timetable"][days[now.weekday - 1]];
      for (var j = 0; j < tt.length; j++) {
        tt1.add({"startTime": "xx"});
      }
      for (var i = 0; i < tt.length; i++) {
        if (int.parse(tt[i]["startTime"].split(':')[0]) >= 1 &&
            int.parse(tt[i]["startTime"].split(':')[0]) < 8) {
          tt1[i]["startTime"] = DateFormat("yyyy-MM-dd").format(now) +
              " " +
              hours[int.parse(tt[i]["startTime"].split(':')[0])] +
              ":";
          if ((int.parse(tt[i]["startTime"].split(':')[1])).toString() == "0") {
            tt1[i]["startTime"] = tt1[i]["startTime"] + "00";
          } else {
            tt1[i]["startTime"] = tt1[i]["startTime"] +
                (int.parse(tt[i]["startTime"].split(':')[1])).toString();
          }
          tt1[i]["startTime"] = tt1[i]["startTime"] + ":" + "00";
        } else {
          tt1[i]["startTime"] = DateFormat("yyyy-MM-dd").format(now) + " ";
          if ((tt[i]["startTime"].split(':')[0]).length < 2) {
            tt1[i]["startTime"] = tt1[i]["startTime"] +
                "0" +
                tt[i]["startTime"].split(':')[0] +
                ":";
          } else {
            tt1[i]["startTime"] =
                tt1[i]["startTime"] + tt[i]["startTime"].split(':')[0] + ":";
          }
          if ((int.parse(tt[i]["startTime"].split(':')[1])).toString() == "0") {
            tt1[i]["startTime"] = tt1[i]["startTime"] + "00";
          } else {
            tt1[i]["startTime"] = tt1[i]["startTime"] +
                (int.parse(tt[i]["startTime"].split(':')[1])).toString();
          }
          tt1[i]["startTime"] = tt1[i]["startTime"] + ":" + "00";
        }
        timeNotifications.add(DateTime.parse(tt1[i]["startTime"]));
      }
    } else {
      tt = [
        {"Saturday": "Sit back and relax"},
      ];
    }
  }

  void refreshData() async {
    API api = API();
    String t = widget.profileData['APItoken'].toString();
    regNo = widget.profileData["RegNo"];
    pass = widget.password;
    Map<String, String> data = {
      "token": t,
      "username": regNo,
      "password": pass
    };
    String url = 'http://134.209.150.24/api/vtop/sync';
    Map<String, dynamic> newData = await api.getAPIData(url, data);
    print('Classes');
    print('Marks');
    Map<String, dynamic> newAtt = {};
    newAtt["attendance"] = newData["attendance"];
    Map<String, dynamic> newMarks = {};
    newMarks["marks"] = newData["marks"];
    if (newAtt != null) {
      widget.attendanceData = newAtt;
    }
    if (newMarks != null) {
      widget.marksData = newMarks;
    }
    String u = widget.profileData['RegNo'].toString();
    Student student = Student(
        profileKey: (u + "-profile"),
        profile: widget.profileData,
        attendanceKey: (u + "-attendance"),
        attendance: widget.attendanceData,
        timeTableKey: (u + "-timeTable"),
        timeTable: widget.timeTableData,
        marksKey: (u + "-marks"),
        marks: widget.marksData,
        acadHistoryKey: (u + "-acadHistory"),
        acadHistory: widget.acadHistoryData);
    StudentDao().deleteStudent(student);
    StudentDao().insertStudent(student);
    getAttendance();
    getTimeTable();
    setState(() {
      refresh = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getSlots();
    h = 1;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: refresh,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(13, 50, 77, 100),
                Color.fromRGBO(0, 0, 10, 10)
              ])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    setState(
                      () {
                        refresh = true;
                      },
                    );
                    refreshData();
                    // do something
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          //color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Card(
                          color: Colors.transparent,
                          //margin: EdgeInsets.all(15),
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Texts("Average Attendance", 18),
                                    Texts(
                                        attDetails["Attended"].toString() +
                                            "/" +
                                            attDetails["Total"].toString(),
                                        16),
                                  ],
                                ),
                              ),
                              AnimatedCircularChart(
                                duration: Duration(milliseconds: 900),
                                chartType: CircularChartType.Radial,
                                key: k.chartKey,
                                size: const Size(130.0, 130.0),
                                initialChartData: <CircularStackEntry>[
                                  CircularStackEntry(
                                    <CircularSegmentEntry>[
                                      CircularSegmentEntry(
                                        pie["Present"],
                                        Colors.blue[800],
                                        rankKey: 'completed',
                                      ),
                                      CircularSegmentEntry(
                                        pie["Absent"],
                                        Colors.blue[300],
                                        rankKey: 'remaining',
                                      ),
                                    ],
                                    rankKey: 'progress',
                                  ),
                                ],
                                percentageValues: true,
                                edgeStyle: SegmentEdgeStyle.round,
                                holeLabel:
                                    attDetails["Percentage"].toString() + "%",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Divider(color: Colors.grey),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 1),
                        child: Texts(
                            days[now.weekday - 1].toString() + " - TimeTable",
                            20),
                      ),
                      SizedBox(height: 10),
                      now.weekday < 7
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Texts(
                                          theory.toString() + " Theory ", 15),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.bookOpen,
                                      size: 16,
                                      color: Colors.lightBlue,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Texts(
                                              "  |  " +
                                                  labs.toString() +
                                                  " Lab(s) ",
                                              15),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.laptopCode,
                                          size: 16,
                                          color: Colors.lightBlue,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(0),
                      //margin: EdgeInsets.all(10),
                      width: double.infinity,
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          Column(
                            children: tt.map((e) {
                              List<Map<String, dynamic>> bunk = [];
                              if (now.weekday < 7) {
                                if (count < timeNotifications.length)
                                  scheduleNotification(
                                      timeNotifications[count++],
                                      e["courseName"],
                                      e["startTime"],
                                      e["class"]);
                                var att = 80;
                                for (var i = 0;
                                    i <
                                        widget.attendanceData["attendance"]
                                            .length;
                                    i++) {
                                  var slot = e["slot"];
                                  if (slot.contains("L")) {
                                    if (widget.attendanceData["attendance"]
                                                [attKeys[i]]["courseName"] ==
                                            e["courseName"] &&
                                        (widget.attendanceData["attendance"]
                                                    [attKeys[i]]["type"]
                                                .contains("Lab") ||
                                            widget.attendanceData["attendance"]
                                                    [attKeys[i]]["type"]
                                                .contains("Soft"))) {
                                      Map<String, dynamic> bu =
                                          widget.attendanceData["attendance"]
                                              [attKeys[i]];
                                      bunk.add(bu);
                                      att = widget.attendanceData["attendance"]
                                          [attKeys[i]]["percentage"];
                                      break;
                                    }
                                  } else {
                                    if (widget.attendanceData["attendance"]
                                                [attKeys[i]]["courseName"] ==
                                            e["courseName"] &&
                                        (widget.attendanceData["attendance"]
                                                    [attKeys[i]]["type"]
                                                .contains("Theory") ||
                                            widget.attendanceData["attendance"]
                                                    [attKeys[i]]["type"]
                                                .contains("Soft") ||
                                            !widget.attendanceData["attendance"]
                                                    [attKeys[i]]["type"]
                                                .contains("Lab"))) {
                                      Map<String, dynamic> bu =
                                          widget.attendanceData["attendance"]
                                              [attKeys[i]];
                                      bunk.add(bu);
                                      att = widget.attendanceData["attendance"]
                                          [attKeys[i]]["percentage"];
                                      break;
                                    }
                                  }
                                }
                                var color1 = Colors.blue[800];
                                var color2 = Colors.blue[300];
                                if (att < 80 && att >= 75) {
                                  color1 = Colors.yellow[900];
                                  color2 = Colors.yellow[400];
                                } else if (att < 75) {
                                  color1 = Colors.red[900];
                                  color2 = Colors.red[300];
                                }
                                return MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BunkMeter(bunk, 0),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: color1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Texts(
                                                        e["code"] +
                                                            " - " +
                                                            e["courseName"],
                                                        16),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: <Widget>[
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .mapMarkerAlt,
                                                            size: 16,
                                                            color: color1),
                                                        SizedBox(width: 5),
                                                        Texts(e["class"], 14),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: <Widget>[
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .clock,
                                                            size: 16,
                                                            color: color1),
                                                        SizedBox(width: 5),
                                                        Texts(
                                                            e["startTime"] +
                                                                " - " +
                                                                e["endTime"],
                                                            14),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: <Widget>[
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .tag,
                                                            size: 16,
                                                            color: color1),
                                                        SizedBox(width: 8),
                                                        Texts(e["slot"], 14),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
//                                        SizedBox(width: 20),
                                              CircularPercentIndicator(
                                                animationDuration: 900,
                                                radius: 90.0,
                                                lineWidth: 6.0,
                                                percent: double.parse(
                                                        att.toString()) /
                                                    100,
                                                center: Texts(
                                                    att.toString() + "%", 15),
                                                progressColor: color1,
                                                backgroundColor: color2,
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (h == 1) {
                                h++;
                                return Column(
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    Container(
                                        child: Texts(
                                            "No Classes today, Sit back and relax.",
                                            18)),
                                    SizedBox(height: 40),
                                    Divider(color: Colors.grey),
                                    SizedBox(height: 10),
                                    Container(
                                      child: Texts(
                                          "Maybe work on some assignments.",
                                          18),
                                      padding: EdgeInsets.only(top: 15),
                                    ),
                                    SizedBox(height: 10),
//                                Padding(
//                                  padding: EdgeInsets.symmetric(vertical: 16.0),
//                                  child: Material(
//                                      elevation: 5.0,
//                                      color: Colors.indigo,
//                                      borderRadius: BorderRadius.circular(30.0),
//                                      child: MaterialButton(
//                                        onPressed: () async {
//                                          SharedPreferences prefs =
//                                              await SharedPreferences
//                                                  .getInstance();
//                                          var moodlePassword = prefs
//                                              .getString("moodle-password");
//                                          if (moodlePassword == null) {
//                                            Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                builder: (context) =>
//                                                    MoodleLogin(
//                                                        widget.profileData[
//                                                            "RegNo"],
//                                                        widget.profileData[
//                                                            "APItoken"]),
//                                              ),
//                                            );
//                                          } else {
//                                            Map<String, dynamic> mod =
//                                                await MoodleDAO().getMoodleData(
//                                                    widget.profileData[
//                                                            "RegNo"] +
//                                                        "-moodle");
//                                            Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                builder: (context) => Moodle(
//                                                  widget.profileData["RegNo"],
//                                                  widget
//                                                      .profileData["APItoken"],
//                                                  mod,
//                                                ),
//                                              ),
//                                            );
//                                          }
//                                        },
//                                        minWidth: 200.0,
//                                        height: 42.0,
//                                        child: Texts('Proceed To Moodle', 12),
//                                      )),
//                                ),
                                    SizedBox(height: 12),
                                    Divider(color: Colors.grey),
                                  ],
                                );
                              }
                              return Container();
                            }).toList(),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child:
                                  Texts("Last Updated On: " + updatedText, 14))
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ),
            drawer: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Drawer(
                  elevation: 1000,
                  child: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          border: Border.all(
                            color: Colors.indigo[900],
                          ),
                          gradient: LinearGradient(
                              end: Alignment.centerLeft,
                              begin: Alignment.centerRight,
                              colors: [
                                //old
                                // Color.fromRGBO(28, 50, 92, 100),
                                // Color.fromRGBO(0, 0, 10, 30)

                                Color.fromRGBO(28, 50, 92, 3),
                                Color.fromRGBO(0, 0, 10, 1)
                              ])),
                      child: ListView(
                        // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          DrawerHeader(
                            padding: EdgeInsets.all(20),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: SafeArea(
                                      child: Image.asset(
                                        'images/blue.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Texts('VITask Lite', 22),
                                ],
                              ),
                            ),
                          ),

//                          Divider(
//                            color: Colors.indigo[800],
//                            thickness: 5,
//                          ),
                          ListTile(
                            leading: Icon(Icons.assessment),
                            dense: true,
                            title: Text(
                              'Attendance',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.normal),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Attendance(widget.attendanceData),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.indigo,
                          ),
                          ListTile(
                            leading: Icon(Icons.event_note),
                            title: Text(
                              'TimeTable',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.normal),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              //print(widget.timeTableData["Timetable"]["Monday"]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimeTable(
                                      widget.timeTableData,
                                      widget.attendanceData),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.indigo,
                          ),
                          ListTile(
                            leading: Icon(Icons.warning),
                            title: Text(
                              'Marks',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.normal),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Marks(widget.marksData),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.indigo,
                          ),
                          ListTile(
                            leading: Icon(Icons.book),
                            title: Text(
                              'Academic History',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.normal),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AcademicHistory(widget.acadHistoryData),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.indigo,
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.calculator),
                            title: Text(
                              'GPA Calculator',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.normal),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GPACalculator(
                                      widget.timeTableData["courses"],
                                      widget.acadHistoryData[
                                          "CurriculumDetails"]["CGPA"],
                                      widget.acadHistoryData[
                                              "CurriculumDetails"]
                                          ["CreditsRegistered"]),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.indigo,
                          ),
//                          ListTile(
//                            leading: Icon(Icons.assignment),
//                            title: Text(
//                              'Moodle',
//                              style: TextStyle(
//                                  fontSize: 14, fontStyle: FontStyle.normal),
//                            ),
//                            onTap: () async {
//                              SharedPreferences prefs =
//                                  await SharedPreferences.getInstance();
//                              var moodlePassword =
//                                  prefs.getString("moodle-password");
//                              if (moodlePassword == null) {
//                                Navigator.pop(context);
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) => MoodleLogin(
//                                      widget.profileData["RegNo"],
//                                      widget.profileData["APItoken"],
//                                    ),
//                                  ),
//                                );
//                              } else {
//                                Map<String, dynamic> mod = await MoodleDAO()
//                                    .getMoodleData(widget.profileData["RegNo"] +
//                                        "-moodle");
//                                Navigator.pop(context);
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) => Moodle(
//                                      widget.profileData["RegNo"],
//                                      widget.profileData["APItoken"],
//                                      mod,
//                                    ),
//                                  ),
//                                );
//                              }
//                            },
//                          ),
//                          Divider(
//                            thickness: 1,
//                            color: Colors.indigo,
//                          ),
                          ListTile(
                            leading: Icon(Icons.info),
                            title: Text(
                              "Profile",
                              //widget.profileData["Name"],
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.normal),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                      widget.acadHistoryData[
                                          "CurriculumDetails"]["CGPA"],
                                      widget.profileData),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 5,
                            color: Colors.indigo,
                          ),
                          //
                          ListTile(
                            leading: Icon(Icons.power_settings_new),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.normal),
                            ),
                            onTap: () async {
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  backgroundColor: Colors.blue[900],
                                  title: Texts(
                                      'Are you sure you want to logout?', 16),
                                  content:
                                      Texts('We hate to see you leave...', 14),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Texts('No', 12),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        logoutUser();
                                      },
                                      child: Texts('Yes', 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

//                          AboutListTile(
//                            applicationName: "VITask",
//                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    await flutterLocalNotificationsPlugin.cancelAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (Route<dynamic> route) => false);
  }

  Future scheduleNotification(
      DateTime t, String c, String startTime, String venue) async {
    if (t.isAfter(DateTime.now())) {
      var scheduledNotificationDateTime = t.subtract(Duration(seconds: 350));
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        //color: Colors.lightBlue,
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(count, c + " - " + venue,
          startTime, scheduledNotificationDateTime, platformChannelSpecifics);
    }
  }

  Future onSelectNotification(String payload) async {
//    showDialog(
//      context: context,
//      builder: (_) {
//        return new AlertDialog(
//          title: Text("PayLoad"),
//          content: Text("Payload : $payload"),
//        );
//      },
//    );
  }
}
