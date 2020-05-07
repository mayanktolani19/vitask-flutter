import 'package:flutter/material.dart';
import 'package:vitask/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Moodle extends StatefulWidget {
  Moodle(this.moodle);
  final Map<String, dynamic> moodle;
  @override
  _MoodleState createState() => _MoodleState();
}

class _MoodleState extends State<Moodle> {
  List<dynamic> assignments;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    assignments = [];
    for (var i = 0; i < widget.moodle["Assignments"].length; i++) {
      assignments.add(widget.moodle["Assignments"][i]);
    }
    print(assignments);
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
          ),
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
                                          size: 22, color: Colors.indigo),
                                      SizedBox(width: 8),
                                      Texts(e["course"], 20),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.clock,
                                          size: 22, color: Colors.indigo),
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
