import 'package:flutter/material.dart';

class AcademicHistory extends StatefulWidget {
  AcademicHistory(this.acadHistory);
  Map<String, dynamic> acadHistory;
  @override
  _AcademicHistoryState createState() => _AcademicHistoryState();
}

class _AcademicHistoryState extends State<AcademicHistory> {
  Map<String, dynamic> acad;
  Map<String, dynamic> curriculum;
  List<Text> courses = [];
  List<Text> numbers = [];
  List<Text> grades = [];
  @override
  void initState() {
    super.initState();
    printData();
    setState(() {
      courses.clear();
      numbers.clear();
    });
  }

  void printData() {
//    print(widget.acadHistory);
    acad = widget.acadHistory['AcadHistory'];
    curriculum = widget.acadHistory['CurriculumDetails'];
//    createLists();
  }

//  void createLists() {
//    acad.forEach((k, v) => courses.add(k));
//    print(courses);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('Academic History'),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            children: <Widget>[getTextWidgets(acad), getGrades(acad)],
          ),
        ),
      ),
    );
  }

  Widget getNumbers(int n) {
    for (var i = 1; i <= n; i++) {
      numbers.add(Text('$i'));
    }
    return Column(children: numbers);
  }

  Widget getGrades(Map<String, dynamic> acad) {
    grades = [];
    acad.forEach((k, v) => grades.add(Text(
          v,
        )));
    return Column(children: grades);
  }

  Widget getTextWidgets(Map<String, dynamic> acad) {
    courses = [];
    acad.forEach((k, v) => courses.add(Text(
          k + "   ",
        )));
    return Column(children: courses);
  }
}
