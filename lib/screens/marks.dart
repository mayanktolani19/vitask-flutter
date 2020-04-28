import 'package:flutter/material.dart';
import 'marksheet.dart';

class Marks extends StatefulWidget {
  Marks(this.marks);
  final Map<String, dynamic> marks;
  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  List<String> courses;
  List<dynamic> mark;

  List<Marksheet> marele = [];
  List<Exam> exeele = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  // void getData() {
  //   m = [];
  //   courses = widget.marks["Marks"].keys.toList();
  //   mark = widget.marks["Marks"].values.toList();
  //   for (var i = 0; i < widget.marks["Marks"].length; i++) {
  //     m.add(widget.marks["Marks"][i]);
  //   }
  //   print(widget.marks);
  //   //print(courses);
  //   //print(mark);
  //   //print(m);
  // }

  void getData() {
    courses = widget.marks["Marks"].keys.toList();
    mark = widget.marks["Marks"].values.toList();
    // print(widget.marks["Marks"].values.toList()[0]);
    // acad.forEach((k, v) => courses.add(
    //       k,
    //     ));

    //print(mark);
    marele = [];
    var num = 0;
    while (num < courses.length) {
      marele.add(Marksheet(subject: courses[num], group: mark[num]));
      num++;
    }
  }

  Widget marlist() {
    return Container(
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
          children: marele.map((mr) {
            return Container(
              width: double.infinity,
              child: Card(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromRGBO(229, 45, 39, 100),
                          Color.fromRGBO(179, 18, 23, 100),
                        ]),
                  ),
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(mr.subject,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10.0),
                            // decoration: BoxDecoration(
                            //   gradient: LinearGradient(
                            //       begin: Alignment.topRight,
                            //       end: Alignment.bottomLeft,
                            //       colors: [
                            //         Color.fromRGBO(229, 45, 39, 100),
                            //         Color.fromRGBO(179, 18, 23, 100),

                            //         // Colors.deepPurpleAccent,
                            //         // Colors.pinkAccent
                            //       ]),
                            //   borderRadius: BorderRadius.circular(7.0),
                            // ),
                            child: minimar(mr.group)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )));
  }

  Widget minimar(var group) {
    List<dynamic> examnames = [];
    List<dynamic> examvalues = [];
    List<Exam> exeele = [];
    group.forEach((k, v) => examnames.add(k));

    group.forEach((k, v) => examvalues.add(v));

    var num = 0;
    while (num < examnames.length) {
      exeele.add(Exam(exname: examnames[num], val: examvalues[num]));
      num++;
    }

    return Container(
        color: Colors.black,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(
          children: exeele.map((e) {
            return Container(
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(e.exname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Container(
                          width: 50,
                          height: 50,
                          color: Color.fromRGBO(450, 0, 0, 5),
                          child: Container(
                            child: Card(
                              color: Colors.black,
                              child: Center(
                                child: Text(e.val,
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            );
          }).toList(),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 61,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        title: Text('Marks'),
        backgroundColor: Color.fromRGBO(200, 25, 25, 60),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: marlist(),
          ),
        ),
      ),
    );
  }
}
