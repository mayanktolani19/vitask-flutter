import 'package:flutter/material.dart';

class AcademicHistory extends StatefulWidget {
  AcademicHistory(this.acadHistory);
  Map<String, dynamic> acadHistory;
  @override
  _AcademicHistoryState createState() => _AcademicHistoryState();
}

class _AcademicHistoryState extends State<AcademicHistory> {
  @override
  void initState() {
    super.initState();
    printData();
  }

  void printData() {
    print(widget.acadHistory['AcadHistory']);
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
