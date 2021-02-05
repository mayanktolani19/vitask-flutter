import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitask/Widgets/drawer_tile.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/Widgets/show_toast.dart';
import 'package:vitask/functions/calculate_attendance.dart';
import 'package:vitask/functions/logout.dart';
import 'package:vitask/functions/navigate_moodle.dart';
import 'package:vitask/functions/notifications.dart';
import 'package:vitask/functions/test_internet.dart';
import 'package:vitask/screens/attendance.dart';
import 'package:vitask/screens/gpa_calculator.dart';
import 'package:vitask/screens/timetable.dart';
import 'package:vitask/screens/marks.dart';
import 'package:vitask/screens/acadhistory.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:vitask/constants.dart';
import 'profile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vitask/api.dart';
import 'package:vitask/database/StudentModel.dart';
import 'package:vitask/database/Student_DAO.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  var now = DateTime.now();
  int count, h, g, theory, labs;
  bool refresh = false;
  var regNo, token, pass;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    if ((widget.profileData != null &&
            widget.acadHistoryData != null &&
            widget.marksData != null &&
            widget.timeTableData != null &&
            widget.attendanceData != null) &&
        (widget.profileData.isNotEmpty &&
            widget.acadHistoryData.isNotEmpty &&
            widget.marksData.isNotEmpty &&
            widget.timeTableData.isNotEmpty &&
            widget.attendanceData.isNotEmpty)) {
      getAttendance();
      getTimeTable();
    }

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
    getMoodleData(widget.profileData);
    super.initState();
  }

  void getAttendance() async {
    attKeys = widget.attendanceData["attendance"].keys.toList();
    CalculateAttendance cal =
        CalculateAttendance(widget.attendanceData, widget.profileData["RegNo"]);
    setState(() {
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
    if (now.weekday < 6) {
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
    if (now.weekday < 6) {
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
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MMMM-dd-HH-mm');
    String update = formatter.format(now);
    List<String> updated = update.split('-');
    updatedText = "";
    setState(() {
      updatedText = updated[2] +
          " " +
          updated[1].substring(0, 3) +
          " " +
          updated[3] +
          ":" +
          updated[4];
    });
    API api = API();
    String t = widget.profileData['APItoken'].toString();
    regNo = widget.profileData["RegNo"];
    pass = widget.password;
    Map<String, String> data;
    if (refresh) {
      data = {
        "token": t,
        "username": regNo,
        "password": pass,
        "hardRefresh": "True"
      };
    } else
      data = {"token": t, "username": regNo, "password": pass};
    bool internet = await testInternet();
    if (internet) {
      showToast('Refreshing....', Colors.blue[500]);
      String url = 'http://134.209.150.24/api/vtop/sync';
      Map<String, dynamic> newData = {};
      try {
        newData = await api
            .getAPIData(url, data)
            .timeout(const Duration(seconds: 10));
      } on TimeoutException catch (_) {
        showToast('Something went wrong', Colors.red);
        setState(() {
          refresh = false;
        });
      } catch (e) {
        showToast('Something went wrong', Colors.red);
        setState(() {
          refresh = false;
        });
      }
      Map<String, dynamic> newAtt = {};
      newAtt["attendance"] = newData["attendance"];
      Map<String, dynamic> newMarks = {};
      newMarks["marks"] = newData["marks"];
      if (newAtt != null) {
        setState(() {
          widget.attendanceData = newAtt;
        });
      }
      if (newMarks != null) {
        setState(() {
          widget.marksData = newMarks;
        });
      }
      if (refresh) {
        Map<String, dynamic> newAcad = {};
        newAcad["acadHistory"] = newData["acadHistory"]["subjects"];
        newAcad["CurriculumDetails"] = newData["acadHistory"]["summary"];
        if (newAcad != null) {
          setState(() {
            widget.acadHistoryData = newAcad;
          });
        }
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
      showToast('Resynced ✅', Colors.blue[500]);
      setState(() {
        refresh = false;
      });
    } else {
      showToast('Please check your internet and try again', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    h = 1;
    getSlots();
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: refresh,
        child: Container(
          decoration: BoxDecoration(gradient: gradient()),
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
                  tooltip: "Refresh",
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    bool internet = await testInternet();
                    if (internet) {
                      setState(
                        () {
                          refresh = true;
                        },
                      );
                      refreshData();
                    } else {
                      showToast('Please check your internet and try again',
                          Colors.red);
                    }
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: widget.timeTableData.isNotEmpty
                  ? Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                //color: Colors.redAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Card(
                                color: Colors.transparent,
                                //margin: EdgeInsets.all(15),
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Texts("Average Attendance", 18),
                                          Texts(
                                              attDetails["Attended"]
                                                      .toString() +
                                                  "/" +
                                                  attDetails["Total"]
                                                      .toString(),
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
                                          attDetails["Percentage"].toString() +
                                              "%",
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
                                  days[now.weekday - 1].toString() +
                                      " - TimeTable",
                                  20),
                            ),
                            SizedBox(height: 10),
                            now.weekday < 6
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Texts(
                                                theory.toString() + " Theory ",
                                                15),
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
                                    if (now.weekday < 6) {
                                      if (count < timeNotifications.length)
                                        scheduleNotification(
                                            timeNotifications[count++],
                                            e["courseName"],
                                            e["startTime"],
                                            e["class"],
                                            flutterLocalNotificationsPlugin,
                                            count);
                                      var att = 80;
                                      for (var i = 0;
                                          i <
                                              widget
                                                  .attendanceData["attendance"]
                                                  .length;
                                          i++) {
                                        var slot = e["slot"];
                                        if (slot.contains("L")) {
                                          if (widget.attendanceData[
                                                              "attendance"]
                                                          [attKeys[i]]
                                                      ["courseName"] ==
                                                  e["courseName"] &&
                                              (widget.attendanceData[
                                                          "attendance"]
                                                          [attKeys[i]]["type"]
                                                      .contains("Lab") ||
                                                  widget.attendanceData[
                                                          "attendance"]
                                                          [attKeys[i]]["type"]
                                                      .contains("Soft"))) {
                                            Map<String, dynamic> bu =
                                                widget.attendanceData[
                                                    "attendance"][attKeys[i]];
                                            bunk.add(bu);
                                            att = widget.attendanceData[
                                                    "attendance"][attKeys[i]]
                                                ["percentage"];
                                            break;
                                          }
                                        } else {
                                          if (widget.attendanceData["attendance"]
                                                          [attKeys[i]]
                                                      ["courseName"] ==
                                                  e["courseName"] &&
                                              (widget.attendanceData["attendance"]
                                                          [attKeys[i]]["type"]
                                                      .contains("Theory") ||
                                                  widget.attendanceData["attendance"]
                                                          [attKeys[i]]["type"]
                                                      .contains("Soft") ||
                                                  !widget.attendanceData[
                                                          "attendance"]
                                                          [attKeys[i]]["type"]
                                                      .contains("Lab"))) {
                                            Map<String, dynamic> bu =
                                                widget.attendanceData[
                                                    "attendance"][attKeys[i]];
                                            bunk.add(bu);
                                            att = widget.attendanceData[
                                                    "attendance"][attKeys[i]]
                                                ["percentage"];
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
                                        onPressed: bunk.isNotEmpty
                                            ? () {
                                                print(bunk);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BunkMeter(bunk, 0),
                                                  ),
                                                );
                                              }
                                            : null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: color1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                                  color:
                                                                      color1),
                                                              SizedBox(
                                                                  width: 5),
                                                              Texts(e["class"],
                                                                  14),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8),
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                  FontAwesomeIcons
                                                                      .clock,
                                                                  size: 16,
                                                                  color:
                                                                      color1),
                                                              SizedBox(
                                                                  width: 5),
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
                                                                  color:
                                                                      color1),
                                                              SizedBox(
                                                                  width: 8),
                                                              Texts(e["slot"],
                                                                  14),
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
                                                          att.toString() + "%",
                                                          15),
                                                      progressColor: color1,
                                                      backgroundColor: color2,
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
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
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Material(
                                                elevation: 5.0,
                                                color: Colors.indigo,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    navigateMoodle(context,
                                                        widget.profileData);
                                                  },
                                                  minWidth: 200.0,
                                                  height: 42.0,
                                                  child: Texts(
                                                      'Proceed To Moodle', 12),
                                                )),
                                          ),
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
                                    child: Texts(
                                        "Last Updated On: " + updatedText, 14))
                              ],
                            )),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                            child: Texts(
                                "No Classes today, Sit back and relax.", 18)),
                        SizedBox(height: 40),
                        Divider(color: Colors.grey),
                        SizedBox(height: 10),
                        Container(
                          child: Texts("Maybe work on some assignments.", 18),
                          padding: EdgeInsets.only(top: 15),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Material(
                            elevation: 5.0,
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        SizedBox(height: 12),
                        Divider(color: Colors.grey),
                      ],
                    ),
            ),
            drawer: widget.attendanceData.isNotEmpty &&
                    widget.timeTableData.isNotEmpty &&
                    widget.profileData.isNotEmpty &&
                    widget.acadHistoryData.isNotEmpty &&
                    widget.marksData.isNotEmpty
                ? Container(
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
                                drawerTile(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Attendance(widget.attendanceData),
                                    ),
                                    Icon(Icons.assessment),
                                    'Attendance'),
                                div(),
                                widget.timeTableData.isNotEmpty &&
                                        widget.attendanceData.isNotEmpty
                                    ? drawerTile(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TimeTable(
                                              widget.timeTableData,
                                              widget.attendanceData),
                                        ),
                                        Icon(Icons.event_note),
                                        'TimeTable',
                                      )
                                    : Container(),
                                div(),
                                drawerTile(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Marks(widget.marksData),
                                    ),
                                    Icon(Icons.warning),
                                    'Marks'),
                                div(),
                                drawerTile(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AcademicHistory(
                                          widget.acadHistoryData),
                                    ),
                                    Icon(Icons.book),
                                    'Academic History'),
                                div(),
                                widget.timeTableData.isNotEmpty &&
                                        widget.attendanceData.isNotEmpty
                                    ? drawerTile(
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
                                        Icon(FontAwesomeIcons.calculator),
                                        'GPA Calculator')
                                    : Container(),
                                div(),
                                ListTile(
                                  leading: Icon(Icons.assignment),
                                  title: Text(
                                    'Moodle',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  onTap: () async {
                                    navigateMoodle(context, widget.profileData);
                                  },
                                ),
                                div(),
                                drawerTile(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(
                                          widget.acadHistoryData[
                                              "CurriculumDetails"]["CGPA"],
                                          widget.profileData),
                                    ),
                                    Icon(Icons.info),
                                    "Profile"),
                                Divider(
                                  thickness: 5,
                                  color: Colors.indigo,
                                ),
                                ListTile(
                                  leading: Icon(Icons.power_settings_new),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        backgroundColor: Colors.blue[900],
                                        title: Texts(
                                            'Are you sure you want to logout?',
                                            16),
                                        content: Texts(
                                            'We hate to see you leave...', 14),
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
                                              logoutUser(context,
                                                  flutterLocalNotificationsPlugin);
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
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
