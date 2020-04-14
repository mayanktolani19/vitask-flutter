import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  Attendance(this.attendance);
  Map<String, dynamic> attendance;
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  void initState() {
    super.initState();
    printData();
  }

  void printData() {
    if (widget.attendance != null)
      print(widget.attendance['Slots']);
    else
      print("Attendance is null");
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
