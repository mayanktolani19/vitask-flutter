import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vitask/api.dart';
import 'package:vitask/screens/attendance.dart';
import 'package:vitask/screens/timetable.dart';
import 'package:vitask/screens/marks.dart';
import 'package:vitask/screens/acadhistory.dart';
import 'package:vitask/screens/moodle.dart';

class MenuDashboardPage extends StatefulWidget {
  MenuDashboardPage(this.profileData);
  Map<String, dynamic> profileData;
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.red[800],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.red[900], Colors.red[500]]),
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
            ),
            height: 300,
            width: 350,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Texts('Welcome,', 30),
                Texts(widget.profileData['Name'], 25),
                Texts(widget.profileData['RegNo'], 25),
                Texts(widget.profileData['Branch'], 25),
              ],
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.red[900], Colors.red[500]]),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  height: 200,
                  width: 350,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Texts('Attendance', 30),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.red[900], Colors.red[500]]),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  height: 200,
                  width: 350,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Texts('Time Table', 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
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
                      child: Image.asset(
                        'images/blue.png',
                        width: 150,
                        height: 100,
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
                API attendance = API('https://vitask.me/classesapi?token=' +
                    widget.profileData["APItoken"]);
                Map<String, dynamic> tt = await attendance.getAPIData();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Attendance(tt),
                  ),
                );
              },
            ),
            ListTile(
              title: Texts('Time Table', 20),
              onTap: () async {
                API timetable = API('https://vitask.me/timetableapi?token=' +
                    widget.profileData["APItoken"]);
                Map<String, dynamic> tt = await timetable.getAPIData();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeTable(tt),
                  ),
                );
              },
            ),
            ListTile(
              title: Texts('Marks', 20),
              onTap: () async {
                API marks = API('https://vitask.me/marksapi?token=' +
                    widget.profileData["APItoken"]);
                Map<String, dynamic> m = await marks.getAPIData();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Marks(m),
                  ),
                );
              },
            ),
            ListTile(
              title: Texts('Academic History', 20),
              onTap: () async {
                API academicHistory = API(
                    'https://vitask.me/acadhistoryapi?token=' +
                        widget.profileData["APItoken"]);
                Map<String, dynamic> academic =
                    await academicHistory.getAPIData();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcademicHistory(academic),
                  ),
                );
              },
            ),
            ListTile(
              title: Texts('Moodle', 20),
              onTap: () async {
                API moodle = API('https://vitask.me/moodleapi?token=' +
                    widget.profileData["APItoken"]);
                Map<String, dynamic> mod = await moodle.getAPIData();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Moodle(mod),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Texts extends StatelessWidget {
  String text;
  double fontSize;
  Texts(this.text, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
