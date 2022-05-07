import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/constants.dart';

class GPACalculator extends StatefulWidget {
  final Map<String, dynamic>? courses;
  final cgpa, creditsRegistered;
  GPACalculator(this.courses, this.cgpa, this.creditsRegistered);
  @override
  _GPACalculatorState createState() => _GPACalculatorState();
}

class _GPACalculatorState extends State<GPACalculator> {
  var newCgpa, gpa, currentCredits;
  late List courses;
  late List credits;
  late List values;
  @override
  void initState() {
    super.initState();
    gpa = 9.0;
    courses = widget.courses!.keys.toList();
    credits = widget.courses!.values.toList();
    values = [];
    currentCredits = 0;
    for (var i = 0; i < credits.length; i++) {
      currentCredits = currentCredits + credits[i];
      values.add(9.0);
    }
    calculateGpa();
    calculateNewCgpa();
  }

  calculateGpa() {
    double sum = 0.0;
    for (var i = 0; i < credits.length; i++) {
      sum = sum + double.parse(credits[i].toString()) * values[i];
    }

    setState(() {
      gpa = double.parse((sum / currentCredits).toString());
    });
  }

  calculateNewCgpa() {
    newCgpa = (double.parse(widget.creditsRegistered.toString()) *
                double.parse(widget.cgpa.toString()) +
            double.parse(gpa.toString()) *
                double.parse(currentCredits.toString())) /
        (double.parse(currentCredits.toString()) +
            double.parse(widget.creditsRegistered.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(gradient: gradient()),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'GPA Calculator',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Texts('Current CGPA', 15),
                            Texts(widget.cgpa, 16)
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Texts('New CGPA', 15),
                            Texts(newCgpa.toStringAsFixed(2), 16)
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Texts("GPA", 15),
                              Texts(gpa.toStringAsFixed(2), 16)
                            ],
                          )),
                      Divider(color: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 15),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: courses.map((m) {
                      return Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Texts(m.toString(), 15),
                            SizedBox(height: 5),
                            Texts(
                                credits[courses.indexOf(m)].toString() +
                                    " Credits",
                                15),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 11,
                                  child: Slider(
                                    min: 4,
                                    max: 10,
                                    divisions: 6,
                                    value: values[courses.indexOf(m)],
                                    onChanged: (double value) {
                                      setState(() {
                                        values[courses.indexOf(m)] = value;
                                      });
                                      calculateGpa();
                                      calculateNewCgpa();
                                    },
                                  ),
                                ),
                                Expanded(flex: 1, child: SizedBox()),
                                Expanded(
                                  flex: 2,
                                  child: values[courses.indexOf(m)] == 10.0
                                      ? ClipRect(
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.yellow[800],
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "S",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              )))
                                      : values[courses.indexOf(m)] == 9.0
                                          ? ClipRect(
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "A",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  )))
                                          : values[courses.indexOf(m)] == 8.0
                                              ? ClipRect(
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "B",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black),
                                                      )))
                                              : values[courses.indexOf(m)] ==
                                                      7.0
                                                  ? ClipRect(
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          margin:
                                                              EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.blueGrey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "C",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black),
                                                          )))
                                                  : values[courses.indexOf(m)] ==
                                                          6.0
                                                      ? ClipRect(
                                                          child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      5),
                                                              margin: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .deepOrange,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "D",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black),
                                                              )))
                                                      : values[courses.indexOf(m)] ==
                                                              5.0
                                                          ? ClipRect(
                                                              child: Container(
                                                                  padding: EdgeInsets.all(5),
                                                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    "E",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black),
                                                                  )))
                                                          : ClipRect(
                                                              child: Container(
                                                                  padding: EdgeInsets.all(5),
                                                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                            .red[
                                                                        800],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    "F",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black),
                                                                  ))),
                                ),
                                Expanded(flex: 1, child: SizedBox())
                              ],
                            ),
                            SizedBox(height: 25),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
