import 'package:flutter/material.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/screens/classacad.dart';
import 'package:vitask/constants.dart';

class AcademicHistory extends StatefulWidget {
  AcademicHistory(this.acadHistory);
  final Map<String, dynamic>? acadHistory;
  @override
  _AcademicHistoryState createState() => _AcademicHistoryState();
}

class _AcademicHistoryState extends State<AcademicHistory> {
  Map<String, dynamic>? acad;
  Map<String, dynamic>? curriculum;
  List<String> courses = [];
  List<Text> numbers = [];
  List<String> grades = [];
  List<Acad> elements = [];

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      courses.clear();
      numbers.clear();
    });
  }

  void getData() {
    acad = widget.acadHistory!['acadHistory'];
    curriculum = widget.acadHistory!['CurriculumDetails'];
  }

  Widget summary(Map<String, dynamic> curriculum) {
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.blue[900],
      //   borderRadius: BorderRadius.all(Radius.circular(20)),
      //   border: Border.all(
      //     color: Colors.blue[700],
      //   ),
      // ),
      height: height / 4,
      width: width / 1.09,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Texts("CGPA", 18),
                Texts(curriculum['CGPA'], 18),
              ],
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Texts("Credits Registered", 18),
                Texts("${curriculum['CreditsRegistered']}", 18),
              ],
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Texts("Credits Earned", 18),
                Texts("${curriculum['CreditsEarned']}", 18),
              ],
            ),
            // SizedBox(height: 3),
            Divider(color: Colors.white),
            Container(
              // padding: EdgeInsets.all(4),
              // decoration: BoxDecoration(
              //   color: Color.fromRGBO(33, 35, 87, 100),
              //   borderRadius: BorderRadius.all(Radius.circular(5)),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Texts("S", 18),
                  Texts("A", 18),
                  Texts("B", 18),
                  Texts("C", 18),
                  Texts("D", 18),
                  Texts("E", 18),
                  Texts("F", 18),
                ],
              ),
            ),
            Divider(color: Colors.white),
            // SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Texts(curriculum['S'], 18),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Texts(curriculum['A'], 18),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Texts(curriculum['B'], 18),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Texts(curriculum['C'], 18),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Texts(curriculum['D'], 18),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Texts(curriculum['E'], 18),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Texts(curriculum['F'], 18),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget elelist(Map<String, dynamic> acad) {
    double width = MediaQuery.of(context).size.width;
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
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  //
                  margin: EdgeInsets.all(7),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.blue[700]!,
                    ),
                  ),
                  //
                  height: 80,
                  width: width / 1.09,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 20,
                        bottom: 10,
                        left: 10,
                        right: 50,
                        child: Texts(e.subject, 15),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: ClipOval(
                          child: Container(
                            height: 49,
                            width: 45,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.indigo,
                                  Colors.blue[900]!,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    e.grade,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.greenAccent,
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(gradient: gradient()),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 10,
              floating: true,
              pinned: false,
              title: Text(
                "Academic History",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  child: Column(
                children: <Widget>[
                  Material(
                    type: MaterialType.transparency,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(50, 57, 250, 170),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      //
                      height: height / 3,
                      width: width / 1.09,
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topCenter,
                              child: Texts('Your Curriculum Details', 20)),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: summary(curriculum!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  elelist(acad!),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
