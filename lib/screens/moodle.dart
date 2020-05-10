import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitask/api.dart';
import 'package:vitask/database/Moodle_DAO.dart';
import 'package:vitask/database/MoodleModel.dart';

class Moodle extends StatefulWidget {
  Moodle(this.reg, this.appNo, this.moodle);
  Map<String, dynamic> moodle;
  final String reg, appNo;
  @override
  _MoodleState createState() => _MoodleState();
}

class _MoodleState extends State<Moodle> {
  List<dynamic> assignments;
  bool refresh = false;
  var r, p, a;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    assignments = [];
    if (widget.moodle != null) {
      for (var i = 0; i < widget.moodle["Assignments"].length; i++) {
        assignments.add(widget.moodle["Assignments"][i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: refresh,
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
                title: Text('Moodle'),
                elevation: 0,
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
                          widget.moodle = moodleData;
                          MoodleData m = MoodleData(r + "-moodle", moodleData);
                          MoodleDAO().deleteStudent(m);
                          MoodleDAO().insertMoodleData(m);
                          getData();
                        }
                        setState(() {
                          refresh = false;
                        });
                      })
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
                                        Texts(e["course"], 18),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.clock,
                                            size: 20, color: Colors.indigo),
                                        SizedBox(width: 8),
                                        Texts(e["time"], 16),
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
      ),
    );
  }
}
