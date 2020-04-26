import 'package:flutter/material.dart';

class Moodle extends StatefulWidget {
  Moodle(this.moodle);
  final Map<String, dynamic> moodle;
  @override
  _MoodleState createState() => _MoodleState();
}

class _MoodleState extends State<Moodle> {
  @override
  void initState() {
    super.initState();
    printData();
  }

  void printData() {
    print(widget.moodle['Assignments']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//        child: Column(
//      children: <Widget>[
//        for (var item in acadList) new Text(),
//      ],
//    )
        );
  }
}
