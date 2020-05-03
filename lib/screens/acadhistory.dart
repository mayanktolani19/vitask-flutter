import 'package:flutter/material.dart';
import 'package:vitask/screens/classacad.dart';

class AcademicHistory extends StatefulWidget {
  AcademicHistory(this.acadHistory);
  final Map<String, dynamic> acadHistory;
  @override
  _AcademicHistoryState createState() => _AcademicHistoryState();
}

class _AcademicHistoryState extends State<AcademicHistory> {
  Map<String, dynamic> acad;
  Map<String, dynamic> curriculum;
  List<String> courses = [];
  List<Text> numbers = [];
  List<String> grades = [];
  List<Acad> elements = [];

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
    acad = widget.acadHistory['AcadHistory'];
    curriculum = widget.acadHistory['CurriculumDetails'];
  }

  Widget elelist(Map<String, dynamic> acad) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    grades = [];
    acad.forEach((k, v) => grades.add(v));
    courses = [];
    acad.forEach((k, v) => courses.add(
          k,
        ));
    elements = [];
    var num = 0;
    while (num < grades.length) {
      elements.add(Acad(subject: courses[num], grade: grades[num].toString()));
      num++;
    }

    return SingleChildScrollView(
      child: Column(
        children: elements.map(
          (e) {
            return Container(
              child: Card(
                color: Colors.black,
                child: Container(
                  //
                  margin: EdgeInsets.all(7),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.blueAccent,
                    ),
                  ),
                  //
                  height: 80,
                  width: width / 1.09,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 50,
                        child: Text(
                          e.subject,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: 23,
                            //color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.red[900],
                                  Colors.red[900]
                                ])),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 25,
                                child: Center(
                                  child: Text(
                                    e.grade,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Color.fromRGBO(13, 50, 77, 100),
            Color.fromRGBO(0, 0, 10, 10)
          ])),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 10,
            centerTitle: true,
            floating: true,
            pinned: false,
            title: Text(
              "academic history",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(child: elelist(acad)),
          ),
        ],
      ),
    );
  }
}
