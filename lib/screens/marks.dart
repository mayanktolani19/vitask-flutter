import 'package:flutter/material.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'marksheet.dart';
import 'package:vitask/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    courses = widget.marks['marks'].keys.toList();
    mark = widget.marks['marks'].values.toList();

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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.blueAccent,
                      ),
                    ),
                    child: Container(
                      child: Card(
                        elevation: 0,
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
                              child: Texts(mr.subject, 16),
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
                        AutoSizeText(e.exname),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            // width: 40,
                            // height: 40,
                            //color: Color.fromRGBO(450, 0, 0, 5),
                            color: Colors.indigo,
                            child: Container(
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Center(
                                  child: AutoSizeText(
                                      '${e.val["scored"]}/${e.val["max"]}',
                                      style: TextStyle(
                                        color: Colors.greenAccent[100],
                                        fontSize: 17,
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
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(gradient: gradient()),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  "Marks",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                floating: true,
                pinned: false,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(11.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    marlist(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
