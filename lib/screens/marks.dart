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

  void getData() {
    courses = widget.marks["Marks"].keys.toList();
    mark = widget.marks["Marks"].values.toList();
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
        child: Column(
          children: marele.map((mr) {
            return Container(
              width: double.infinity,
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo,
                            blurRadius: 3,
                            spreadRadius: 0.3,
                          ),
                        ]),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color.fromRGBO(175, 234, 220, 200),
                              Color.fromRGBO(175, 234, 220, 200)
                            ]),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 24, horizontal: 20),
                              child: Text(mr.subject,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromRGBO(236, 150, 150, 3))),
                            ),
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(24.0),
                                child: minimar(mr.group)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ));
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
        color: Colors.transparent,
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
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                fontSize: 17,
                                color: Color.fromRGBO(152, 255, 152, 60))),
                        ClipOval(
                          child: Container(
                            width: 40,
                            height: 40,
                            //color: Color.fromRGBO(450, 0, 0, 5),
                            color: Colors.indigo,
                            child: Container(
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Center(
                                  child: Text(e.val["scored"],
                                      style: TextStyle(
                                        color: Colors.greenAccent[100],
                                        fontSize: 18,
                                      )),
                                ),
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
    return new Scaffold(
      backgroundColor: Color.fromRGBO(0, 22, 60, 10),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            expandedHeight: 90,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Marks",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Image.asset("images/side.jpg", fit: BoxFit.cover),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(11.0),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              // return Card(child: Text('hi'));
              return marlist();
            })),
          ),
        ],
      ),
    );
  }
}
