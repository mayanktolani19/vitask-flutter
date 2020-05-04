import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
import 'package:percent_indicator/percent_indicator.dart';

//import 'package:vitask/screens/moodle.dart';

class MenuDashboardPage extends StatefulWidget {
  MenuDashboardPage(
    this.profileData,
    this.attendanceData,
    this.timeTableData,
    this.marksData,
    this.acadHistoryData,
  );
  Map<String, dynamic> profileData;
  Map<String, dynamic> timeTableData;
  Map<String, dynamic> attendanceData;
  Map<String, dynamic> marksData;
  Map<String, dynamic> acadHistoryData;
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
  var now;
  bool refresh = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    getAttendance();
    getTimeTable();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    chalJaoPlease();
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
    days = [];
    days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    now = DateTime.now();
    if (now.weekday < 6) {
      tt = widget.timeTableData["Timetable"][days[now.weekday - 1]];
    } else {
      tt = [
        {"Saturday": "Sit back and relax"},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //bottom: Radius.circular(10),
              top: Radius.circular(15),
            ),
          ),
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
                String t = widget.profileData['APItoken'].toString();
                String u = widget.profileData['RegNo'].toString();
                widget.attendanceData = await api
                    .getAPIData('https://vitask.me/classesapi?token=$t');
                print('Classes');
                widget.timeTableData = await api
                    .getAPIData('https://vitask.me/timetableapi?token=$t');
                print('Time Table');
                widget.marksData =
                    await api.getAPIData('https://vitask.me/marksapi?token=$t');
                print('Marks');
                widget.acadHistoryData = await api
                    .getAPIData('https://vitask.me/acadhistoryapi?token=$t');
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
                // do something
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(13, 50, 77, 100),
                Color.fromRGBO(0, 0, 10, 10)
              ])),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        //color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Card(
                        color: Colors.transparent,
                        margin: EdgeInsets.all(15),
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Texts("Average Attendance", 30),
                                  Texts(
                                      attDetails["Attended"] +
                                          "/" +
                                          attDetails["Total"],
                                      23),
                                ],
                              ),
                            ),
                            AnimatedCircularChart(
                              duration: Duration(milliseconds: 900),
                              chartType: CircularChartType.Radial,
                              key: k.chartKey,
                              size: const Size(140.0, 140.0),
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
                                      Colors.blue[400],
                                      rankKey: 'remaining',
                                    ),
                                  ],
                                  rankKey: 'progress',
                                ),
                              ],
                              percentageValues: true,
                              edgeStyle: SegmentEdgeStyle.round,
                              holeLabel: attDetails["Percentage"] + "%",
                              labelStyle: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                  ],
                ),
              ),
              Texts(days[now.weekday - 1].toString(), 35),
              SizedBox(height: 10),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(0),
                  //margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(
                    children: tt.map((e) {
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
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
                                              21),
                                          SizedBox(height: 8),
                                          Row(
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.tag,
                                                  size: 17, color: color1),
                                              SizedBox(width: 8),
                                              Text(
                                                e["slot"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: color1,
                                                  fontSize: 22,
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
                                                borderRadius: BorderRadius.all(
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
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                                FontAwesomeIcons
                                                                    .clock,
                                                                size: 17,
                                                                color: color1),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              e["startTime"] +
                                                                  " - ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: color1,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            Text(
                                                              e["endTime"],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: color1,
                                                                fontSize: 20,
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
                                                                size: 17,
                                                                color: color1),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              e["class"],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: color1,
                                                                fontSize: 20,
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
                                      radius: 100.0,
                                      lineWidth: 6.0,
                                      percent:
                                          double.parse(att.toString()) / 100,
                                      center: Texts(att.toString() + "%", 20),
                                      progressColor: color1,
                                      backgroundColor: color2,
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
                                    25)),
                            SizedBox(height: 40),
                            Divider(color: Colors.grey),
                            Container(
                              child:
                                  Texts("Maybe work on some assignments.", 25),
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
            child: SafeArea(
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
                      image: DecorationImage(
                          image: ExactAssetImage("images/side.jpg"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                          Color.fromRGBO(13, 50, 77, 100),
                          Color.fromRGBO(0, 0, 10, 10)
                        ])),
                    child: Column(
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
                                builder: (context) =>
                                    TimeTable(widget.timeTableData),
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
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodleLogin(),
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
                  ),
                ],
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

  Future chalJaoPlease() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 30));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}
