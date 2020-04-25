import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
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
  static var att;
  static var course;
  static var faculty;
  static var code;
  static double percent;
  static var total;
  static var a = 0;
  static var b = 0;
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
    percent = double.parse(attended[ij[0]]["percentage"].toString());
    total = attended[ij[0]]["total"];
    a = 0;
    b = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Card(
                  color: Colors.black45,
                  margin: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      Texts(course.toString() + ' - ' + code.toString(), 26),
                      SizedBox(height: 20),
                      Texts(faculty.toString(), 24),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Card(
                margin: EdgeInsets.all(25),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Texts("Classes Attended", 25),
                          SizedBox(height: 5),
                          Texts(att.toString() + "/" + total.toString(), 20),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
//                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            height: 80,
                            width: 82,
                            margin: EdgeInsets.only(top: 23, left: 15),
                            padding: EdgeInsets.all(20),
                            child: Text(
                              percent.round().toString() + "%",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          PieChart(
                            dataMap: {
                              "present": percent,
                              "absent": 100 - percent
                            },
                            animationDuration: Duration(milliseconds: 800),
                            colorList: [Colors.red, Colors.black12],
                            chartRadius:
                                MediaQuery.of(context).size.width / 4.5,
                            chartValueBackgroundColor: Colors.transparent,
                            decimalPlaces: 1,
                            showLegends: false,
                            showChartValueLabel: true,
                            initialAngle: 180,
                            chartValueStyle: defaultChartValueStyle.copyWith(
                                color: Colors.transparent),
                            chartType: ChartType.ring,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
//                      SizedBox(width: 20),
                            Texts("Attend + " + a.toString(), 25),
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
                                  }
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            Texts("Bunk + " + b.toString(), 25),
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
    );
  }
}
