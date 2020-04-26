import 'package:flutter/material.dart';

class Marks extends StatefulWidget {
  Marks(this.marks);
  final Map<String, dynamic> marks;
  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  List<Map<String, dynamic>> m;
  List<String> courses;
  List<dynamic> mark;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    m = [];
    courses = widget.marks["Marks"].keys.toList();
    mark = widget.marks["Marks"].values.toList();
//    for (var i = 0; i < widget.marks["Marks"].length; i++) {
//      m.add(widget.marks["Marks"][i]);
//    }
//    print(courses);
//    print(mark);
    print(m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          return Text('');
        },
      ),
    );
  }
}
