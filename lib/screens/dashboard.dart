import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitask/functions/calculate_attendance.dart';
import 'package:vitask/screens/attendance.dart';
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

//import 'package:vitask/screens/moodle.dart';

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
  Map<String, dynamic> timeTableData;
  Map<String, dynamic> attendanceData;
  Map<String, dynamic> marksData;
  Map<String, dynamic> acadHistoryData;
  String password;
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

GlobalWidget k = GlobalWidget();

class _MenuDashboardPageState extends State<MenuDashboardPage> {
  String avgAttendance;
  Map<String, String> attDetails = {};
  Map<String, double> pie = {};
  List<String> a;
  List<dynamic> tt;
  List<String> days;
  List<DateTime> time;
  List<String> hours;
  List<DateTime> timeNotifications;
  List<dynamic> tt1;
  var now;
  int count;
  bool refresh = false;
  var regNo;
  var token;
  var pass;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    count = 0;
    getAttendance();
    getTimeTable();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
//    chalJaoPlease(DateTime.now(), "hi");
  }

  void getAttendance() {
    CalculateAttendance cal = CalculateAttendance(widget.attendanceData);
    a = cal.attendanceDetails();
    attDetails["Total"] = a[0];
    attDetails["Attended"] = a[1];
    attDetails["Percentage"] = a[2];
    pie["Present"] = double.parse(a[2]);
    pie["Absent"] = 100 - double.parse(a[2]);
    //print(pie);
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
      tt = widget.timeTableData["Timetable"][days[now.weekday - 1]];
      for (var j = 0; j < tt.length; j++) {
        tt1.add({"startTime": "xx"});
      }
      //print(DateTime.now());
      //print(tt.length);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color.fromRGBO(13, 50, 77, 100),
              Color.fromRGBO(0, 0, 10, 10)
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            title: Text('Dashboard'),
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    refresh = true;
                  });
                  API api = API();
                  pass = widget.password;
                  regNo = widget.profileData["RegNo"];
                  String url =
                      'https://vitask.me/authenticate?username=$regNo&password=$pass';
                  Map<String, dynamic> newProfileData =
                      await api.getAPIData(url);
                  if (newProfileData != null)
                    widget.profileData = newProfileData;
                  if (newProfileData != null) {
                    String t = widget.profileData['APItoken'].toString();
                    String u = widget.profileData['RegNo'].toString();
                    Map<String, dynamic> newAttendanceData = await api
                        .getAPIData('https://vitask.me/classesapi?token=$t');
                    if (newAttendanceData != null)
                      widget.attendanceData = newAttendanceData;
                    print('Classes');
                    Map<String, dynamic> newTimeTableData = await api
                        .getAPIData('https://vitask.me/timetableapi?token=$t');
                    if (newTimeTableData != null)
                      widget.timeTableData = newTimeTableData;
                    print('Time Table');
                    Map<String, dynamic> newMarksData = await api
                        .getAPIData('https://vitask.me/marksapi?token=$t');
                    if (newMarksData != null) widget.marksData = newMarksData;
                    print('Marks');
                    Map<String, dynamic> newAcadHistoryData =
                        await api.getAPIData(
                            'https://vitask.me/acadhistoryapi?token=$t');
                    if (newAcadHistoryData != null)
                      widget.acadHistoryData = newAcadHistoryData;
                    print('AcadHistory');
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
                  // do something
                },
              )
            ],
          ),
          body: Container(
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
                                  Texts("Average Attendance", 22),
                                  Texts(
                                      attDetails["Attended"] +
                                          "/" +
                                          attDetails["Total"],
                                      17),
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
                              holeLabel: attDetails["Percentage"] + "%",
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //Divider(color: Colors.grey),
                  ],
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: Texts(days[now.weekday - 1].toString(), 25)),
                // /SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    //margin: EdgeInsets.all(10),
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Column(
                      children: tt.map((e) {
                        if (count < tt.length)
                          chalJaoPlease(timeNotifications[count++],
                              e["courseName"], e["startTime"], e["class"]);
                        var att = 80;
                        for (var i = 0;
                            i < widget.attendanceData["Attended"].length;
                            i++) {
                          if (widget.attendanceData["Attended"][i]
                                  ["courseName"] ==
                              e["courseName"]) {
                            att = widget.attendanceData["Attended"][i]
                                ["percentage"];
                            break;
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
                        if (now.weekday < 6) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: color1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(9),
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
                                                18),
                                            SizedBox(height: 8),
                                            Row(
                                              children: <Widget>[
                                                Icon(FontAwesomeIcons.tag,
                                                    size: 18, color: color1),
                                                SizedBox(width: 8),
                                                Text(
                                                  e["slot"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: color1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                  left: 60,
                                                  right: 60,
                                                ),
                                                child: Card(
                                                  color: Colors.transparent,
                                                  elevation: 0,
                                                  child: Center(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                  FontAwesomeIcons
                                                                      .clock,
                                                                  size: 18,
                                                                  color:
                                                                      color1),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                e["startTime"] +
                                                                    " - " +
                                                                    e["endTime"],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5),
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
                                                              Text(
                                                                e["class"],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      CircularPercentIndicator(
                                        animationDuration: 900,
                                        radius: 90.0,
                                        lineWidth: 6.0,
                                        percent:
                                            double.parse(att.toString()) / 100,
                                        center: Texts(att.toString() + "%", 18),
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
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              Container(
                                  child: Texts(
                                      "No Classes today, Sit back and relax.",
                                      22)),
                              SizedBox(height: 40),
                              Divider(color: Colors.grey),
                              Container(
                                child: Texts(
                                    "Maybe work on some assignments.", 22),
                                padding: EdgeInsets.only(top: 15),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Material(
                                    elevation: 5.0,
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        print("Moodle button was pressed.");
                                      },
                                      minWidth: 200.0,
                                      height: 42.0,
                                      child: Text(
                                        'Log In To Moodle',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                              SizedBox(height: 15),
                              Divider(color: Colors.grey),
                            ],
                          ),
                        );
                      }).toList(),
                    )),
                  ),
                )
              ],
            ),
          ),
          drawer: SafeArea(
            child: Drawer(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Color.fromRGBO(13, 50, 77, 100),
                      Color.fromRGBO(0, 0, 10, 10)
                    ])),
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Texts('VITask', 35),
                            Container(
                              child: SafeArea(
                                child: Image.asset(
                                  'images/blue.png',
                                  // width: 150,
                                  // height: 100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: ExactAssetImage("images/side.jpg"),
                          //     fit: BoxFit.cover),
                          ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(
                          title: Texts('Attendance', 20),
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
                        ListTile(
                          title: Texts('Time Table', 20),
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
                        ListTile(
                          title: Texts('Marks', 20),
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
                        ListTile(
                          title: Texts('Academic History', 20),
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
                        ListTile(
                          title: Texts('Moodle', 20),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var moodlePassword =
                                prefs.getString("moodle-password");
                            if (moodlePassword == null) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoodleLogin(
                                      widget.profileData["RegNo"],
                                      widget.profileData["AppNo"]),
                                ),
                              );
                            } else {
                              Map<String, dynamic> mod = await MoodleDAO()
                                  .getMoodleData(
                                      widget.profileData["RegNo"] + "-moodle");
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Moodle(
                                    mod,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        ListTile(
                          title: Texts(widget.profileData["Name"], 20),
                          onTap: () async {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                    widget.acadHistoryData["CurriculumDetails"]
                                        ["CGPA"],
                                    widget.profileData),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Texts('Logout', 20),
                          onTap: () async {
                            Navigator.pop(context);
                            logoutUser();
                          },
                        ),
                      ],
                    ),
                  ],
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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (Route<dynamic> route) => false);
  }

  Future chalJaoPlease(
      DateTime t, String c, String startTime, String venue) async {
//    print(t);
//    print(DateTime.now().add(Duration(seconds: 30)));
    //var scheduledNotificationDateTime = t.add(Duration(seconds: 30));
//    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//        'repeating channel id',
//        'repeating channel name',
//        'repeating description');
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    NotificationDetails platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
//        'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
    //await flutterLocalNotificationsPlugin.
//    if (DateTime.now().difference(t) == 0)
    //print(DateTime.now()
    //  .add(Duration(seconds: t.difference(DateTime.now()).inSeconds)));
    //print(t.difference(DateTime.now()).inSeconds);
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
