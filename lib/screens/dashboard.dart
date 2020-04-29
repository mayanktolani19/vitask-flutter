import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vitask/functions/calculate_attendance.dart';
import 'package:vitask/screens/attendance.dart';
import 'package:vitask/screens/timetable.dart';
import 'package:vitask/screens/marks.dart';
import 'package:vitask/screens/acadhistory.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:vitask/constants.dart';
import 'moodle_login.dart';
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

  @override
  void initState() {
    super.initState();
    getAttendance();
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
          title: Text('Profile'),
          backgroundColor: Color.fromRGBO(200, 25, 25, 40),
        ),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Card(
                color: Colors.black45,
                margin: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    Texts(widget.profileData["Name"], 25),
                    SizedBox(height: 15),
                    Texts(widget.profileData["RegNo"], 25),
                    SizedBox(height: 15),
                    Texts(widget.profileData["Branch"], 25),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              decoration: BoxDecoration(
                //color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Card(
                color: Colors.black45,
                margin: EdgeInsets.all(15),
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Texts("Attendance", 30),
                        Texts(
                            attDetails["Attended"] + "/" + attDetails["Total"],
                            18),
                      ],
                    ),
                    new AnimatedCircularChart(
                      duration: Duration(milliseconds: 900),
                      chartType: CircularChartType.Radial,
                      key: k.chartKey,
                      size: const Size(150.0, 150.0),
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              pie["Present"],
                              Colors.red,
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
            Divider(color: Colors.grey)
//            Container(
//              child: ListView.builder(itemBuilder: (context, index) {
//                return Container();
//              }),
//            ),
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
                      print(widget.timeTableData["Timetable"]["Monday"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TimeScreen(widget.timeTableData),
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
}
