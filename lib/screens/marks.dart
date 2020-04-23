import 'package:flutter/material.dart';

class Marks extends StatefulWidget {
  Marks(this.marks);
  final Map<String, dynamic> marks;
  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  @override
  void initState() {
    super.initState();
    printData();
  }

  void printData() {
    print(widget.marks['Marks']);
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
