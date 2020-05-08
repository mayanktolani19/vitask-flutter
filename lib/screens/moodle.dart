import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitask/api.dart';
import 'package:vitask/database/Moodle_DAO.dart';
import 'package:vitask/database/MoodleModel.dart';
import 'package:flutter/animation.dart';

class Moodle extends StatefulWidget {
  Moodle(this.reg, this.appNo, this.moodle);
  Map<String, dynamic> moodle;
  final String reg, appNo;
  @override
  _MoodleState createState() => _MoodleState();
}

class _MoodleState extends State<Moodle> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<dynamic> assignments;
  bool clicked = false;
  var r, p, a;
  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );
    getData();
  }

  void getData() {
    assignments = [];
    for (var i = 0; i < widget.moodle["Assignments"].length; i++) {
      assignments.add(widget.moodle["Assignments"][i]);
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
          appBar: AppBar(
              title: Text('Moodle'),
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget _widget) {
                    return new Transform.rotate(
                      angle: animationController.value * 6.3,
                      child: _widget,
                    );
                  },
                  child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        setState(() {});
                        r = widget.reg;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        p = prefs.getString("moodle-password");
                        a = widget.appNo;
                        String url =
                            "https://vitask.me/moodleapi?username=$r&password=$p&appno=$a";
                        API api = API();
                        Map<String, dynamic> moodleData =
                            await api.getAPIData(url);
                        if (moodleData != null) {
                          print("Moodle");
                          MoodleData m = MoodleData(r + "-moodle", moodleData);
                          MoodleDAO().deleteStudent(m);
                          MoodleDAO().insertMoodleData(m);
                          widget.moodle =
                              await MoodleDAO().getMoodleData(r + "-moodle");
                          getData();
                        }
                      }),
                )
              ]),
          body: SingleChildScrollView(
            child: Column(
                children: assignments.map((e) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.indigo,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(9),
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.graduationCap,
                                          size: 20, color: Colors.indigo),
                                      SizedBox(width: 8),
                                      Texts(e["course"], 20),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.clock,
                                          size: 20, color: Colors.indigo),
                                      SizedBox(width: 8),
                                      Text(
                                        e["time"],
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
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList()),
          ),
        ),
      ),
    );
  }
}
