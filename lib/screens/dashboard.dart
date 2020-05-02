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
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:vitask/constants.dart';
import 'moodle_login.dart';
import 'package:pie_chart/pie_chart.dart';
import 'profile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'package:vitask/screens/moodle.dart';

class MenuDashboardPage extends StatefulWidget {
  MenuDashboardPage(
    this.profileData,
    this.attendanceData,
    this.timeTableData,
    this.marksData,
    this.acadHistoryData,
  );
  final Map<String, dynamic> profileData;
  final Map<String, dynamic> timeTableData;
  final Map<String, dynamic> attendanceData;
  final Map<String, dynamic> marksData;
  final Map<String, dynamic> acadHistoryData;
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //bottom: Radius.circular(10),
              top: Radius.circular(15),
            ),
          ),
          title: Text('Dashboard'),
          backgroundColor: Color.fromRGBO(200, 25, 25, 40),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                          widget.acadHistoryData["CurriculumDetails"]["CGPA"],
                          widget.profileData),
                    ));
                // do something
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
//                  Container(
//                    decoration: BoxDecoration(
//                      color: Colors.black,
//                      borderRadius: BorderRadius.all(Radius.circular(15)),
//                    ),
////                    child: Card(
////                      color: Colors.black45,
////                      margin: EdgeInsets.all(25),
////                      child: Column(
////                        children: <Widget>[
////                          Texts(widget.profileData["Name"], 25),
////                          SizedBox(height: 15),
////                          Texts(widget.profileData["RegNo"], 25),
////                          SizedBox(height: 15),
////                          Texts(widget.profileData["Branch"], 25),
////                        ],
////                      ),
////                    ),
//                  ),
//                  Divider(
//                    color: Colors.grey,
//                  ),
                  Container(
                    decoration: BoxDecoration(
                      //color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Card(
                      color: Colors.black45,
                      margin: EdgeInsets.all(15),
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                          new AnimatedCircularChart(
                            duration: Duration(milliseconds: 3000),
                            chartType: CircularChartType.Radial,
                            key: k.chartKey,
                            size: const Size(140.0, 140.0),
                            initialChartData: <CircularStackEntry>[
                              new CircularStackEntry(
                                <CircularSegmentEntry>[
                                  new CircularSegmentEntry(
                                    pie["Present"],
                                    Colors.indigoAccent,
                                    rankKey: 'completed',
                                  ),
                                  new CircularSegmentEntry(
                                    pie["Absent"],
                                    Colors.blueGrey[600],
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
            Texts(days[now.weekday - 1].toString(), 30),
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
                      if (widget.attendanceData["Attended"][i]["courseName"] ==
                          e["courseName"]) {
                        att =
                            widget.attendanceData["Attended"][i]["percentage"];
                        break;
                      }
                    }
                    var color1;
                    if (att >= 80) {
                      color1 = Colors.blue[400];
                    } else if (att < 80 && att >= 75) {
                      color1 = Colors.yellow[400];
                    } else if (att < 75) {
                      color1 = Colors.red[400];
                    }
                    if (now.weekday < 6) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
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
                                            e["code"] + " - " + e["courseName"],
                                            21),
                                        SizedBox(height: 8),
                                        Texts(e["slot"], 21),
                                        SizedBox(height: 8),
                                        Container(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blueAccent,
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
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          e["startTime"] +
                                                              " - ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color: Colors.blue,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Text(
                                                          e["endTime"],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color: Colors.blue,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      e["class"],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.blue,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
//                              color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        height: 80,
                                        width: 74,
                                        margin:
                                            EdgeInsets.only(top: 23, left: 15),
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "$att%",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      PieChart(
                                        dataMap: {
                                          "present":
                                              double.parse(att.toString()),
                                          "absent": 100 -
                                              double.parse(att.toString()),
                                        },
                                        animationDuration:
                                            Duration(milliseconds: 800),
                                        colorList: [
                                          color1,
                                          Colors.black,
                                        ],
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        chartValueBackgroundColor:
                                            Colors.transparent,
                                        decimalPlaces: 1,
                                        showLegends: false,
                                        showChartValueLabel: true,
                                        initialAngle: 180,
                                        chartValueStyle:
                                            defaultChartValueStyle.copyWith(
                                                color: Colors.transparent),
                                        chartType: ChartType.ring,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                        child:
                            Texts("No Classes today, Sit back and relax", 25));
                  }).toList(),
                )),
              ),
            )
          ],
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
                          builder: (context) => TimeTable(widget.timeTableData),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
