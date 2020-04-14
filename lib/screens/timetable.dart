import 'package:flutter/material.dart';

class TimeTable extends StatefulWidget {
  TimeTable(this.timeTable);
  Map<String, dynamic> timeTable;
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  void initState() {
    super.initState();
    printData();
  }

  void printData() {
    print(widget.timeTable['Timetable']);
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
