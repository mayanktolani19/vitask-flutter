import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/constants.dart';

class BunkMeter extends StatefulWidget {
  BunkMeter(this.current, this.i);
  final List<Map<String, dynamic>> current;
  final i;
  @override
  _BunkMeterState createState() => _BunkMeterState();
}

class _BunkMeterState extends State<BunkMeter> {
  static List<Map<String, dynamic>> attended;
  static List<int> ij;
  static var att, course, faculty, code;
  static double percent;
  static var total, a = 0, b = 0, color1, color2, type;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() {
    ij = [];
    ij.add(widget.i);
    attended = [];
    for (var x = 0; x < widget.current.length; x++) {
      attended.add(widget.current[x]);
    }
    att = attended[ij[0]]["attended"];
    course = attended[ij[0]]["courseName"];
    faculty = attended[ij[0]]["faculty"];
    code = attended[ij[0]]["code"];
    type = attended[ij[0]]["type"];
    percent = double.parse(attended[ij[0]]["percentage"].toString());
    total = attended[ij[0]]["total"];
    color1 = Colors.blue[800];
    color2 = Colors.blue[300];
    if (percent < 80 && percent >= 75) {
      color1 = Colors.yellow[900];
      color2 = Colors.yellow[400];
    } else if (percent < 75) {
      color1 = Colors.red[900];
      color2 = Colors.red[300];
    }
    a = 0;
    b = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(gradient: gradient()),
        child: Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Bunk Meter'),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(7),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: color1,
                      ),
                    ),
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      margin: EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Texts(
                              course.toString() + ' - ' + code.toString(), 18),
                          SizedBox(height: 20),
                          Texts(type.toString(), 16),
                          SizedBox(height: 20),
                          Texts(faculty.toString(), 14),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: color1,
                      ),
                    ),
                    child: Card(
                      margin: EdgeInsets.all(18),
                      color: Colors.transparent,
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Texts("Classes Attended", 16),
                              SizedBox(height: 5),
                              Texts(
                                  att.toString() + "/" + total.toString(), 16),
                            ],
                          ),
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 6.0,
                            percent: double.parse(percent.toString()) / 100,
                            center: Texts(percent.ceil().toString() + "%", 16),
                            progressColor: color1,
                            backgroundColor: color2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
//                      SizedBox(width: 20),
                                Texts("Attend + " + a.toString(), 17),
                              ],
                            ),
                          ),
                          SizedBox(width: 60),
                          Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(FontAwesomeIcons.plus),
                                  onPressed: () {
                                    setState(() {
                                      att++;
                                      a++;
                                      total++;
                                      percent = att / total * 100;
                                      if (percent.ceil() >= 80) {
                                        color1 = Colors.blue[800];
                                        color2 = Colors.blue[300];
                                      } else if (percent.ceil() < 80 &&
                                          percent.ceil() >= 75) {
                                        color1 = Colors.yellow[900];
                                        color2 = Colors.yellow[400];
                                      } else if (percent.ceil() < 75) {
                                        color1 = Colors.red[900];
                                        color2 = Colors.red[300];
                                      }
                                    });
                                  }),
                              IconButton(
                                  icon: Icon(FontAwesomeIcons.minus),
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      if (a > 0) {
                                        att--;
                                        a--;
                                        total--;
                                        percent = att / total * 100;
                                        if (percent.ceil() >= 80) {
                                          color1 = Colors.blue[800];
                                          color2 = Colors.blue[300];
                                        } else if (percent.ceil() < 80 &&
                                            percent.ceil() >= 75) {
                                          color1 = Colors.yellow[900];
                                          color2 = Colors.yellow[400];
                                        } else if (percent.ceil() < 75) {
                                          color1 = Colors.red[900];
                                          color2 = Colors.red[300];
                                        }
                                      }
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              children: <Widget>[
                                Texts("Bunk + " + b.toString(), 17),
                              ],
                            ),
                          ),
                          SizedBox(width: 60),
                          Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(FontAwesomeIcons.plus),
                                  onPressed: () {
                                    setState(() {
                                      total++;
                                      b++;
                                      percent = att / total * 100;
                                      if (percent.ceil() >= 80) {
                                        color1 = Colors.blue[800];
                                        color2 = Colors.blue[300];
                                      } else if (percent.ceil() < 80 &&
                                          percent.ceil() >= 75) {
                                        color1 = Colors.yellow[900];
                                        color2 = Colors.yellow[400];
                                      } else if (percent.ceil() < 75) {
                                        color1 = Colors.red[900];
                                        color2 = Colors.red[300];
                                      }
                                    });
                                  }),
                              IconButton(
                                  color: Colors.red,
                                  icon: Icon(FontAwesomeIcons.minus),
                                  onPressed: () {
                                    setState(() {
                                      if (b > 0) {
                                        b--;
                                        total--;
                                        percent = att / total * 100;
                                        if (percent.ceil() >= 80) {
                                          color1 = Colors.blue[800];
                                          color2 = Colors.blue[300];
                                        } else if (percent.ceil() < 80 &&
                                            percent.ceil() >= 75) {
                                          color1 = Colors.yellow[900];
                                          color2 = Colors.yellow[400];
                                        } else if (percent.ceil() < 75) {
                                          color1 = Colors.red[900];
                                          color2 = Colors.red[300];
                                        }
                                      }
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
