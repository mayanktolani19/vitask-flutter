import 'package:flutter/material.dart';
import 'package:vitask/constants.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:vitask/screens/bunk_meter.dart';

class Attendance extends StatefulWidget {
  Attendance(this.attendance);
  final Map<String, dynamic> attendance;
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  static List<Map<String, dynamic>> attended;
  static int len;
  Map<String, dynamic> current;
  @override
  void initState() {
    super.initState();
    getAttended();
  }

  void getAttended() {
    attended = [];
    for (var i = 0; i < widget.attendance["Attended"].length; i++)
      attended.add(widget.attendance["Attended"][i]);
    len = attended.length;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //bottom: Radius.circular(10),
              top: Radius.circular(15),
            ),
          ),
          title: Text('Attendance'),
          backgroundColor: Color.fromRGBO(200, 25, 25, 40),
        ),
        backgroundColor: Colors.black,
        body: ListView.builder(
            itemCount: len,
            itemBuilder: (BuildContext context, int index) {
              var color1 = Colors.red[400];
              current = attended[index];
              int p = current["percentage"];
              if (p >= 80) {
                color1 = Colors.green[400];
              } else if (p < 80 && p >= 75) {
                color1 = Colors.yellow[400];
              }
              String c = current["courseName"];
              int a = current["attended"];
              int t = current["total"];
              String ty = current["type"];
              Map<String, double> pie = {};
              pie["Present"] = double.parse(p.toString());
              pie["Absent"] = 100 - double.parse(p.toString());
              return Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BunkMeter(attended, index),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.black,
                    margin: EdgeInsets.all(15),
//                  elevation: 10,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Texts(c.toString(), 20),
                                  SizedBox(height: 4),
                                  Texts(ty, 18),
                                  SizedBox(height: 4),
                                  Texts(a.toString() + "/" + t.toString(), 16),
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
                                      "$p%",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  PieChart(
                                    dataMap: pie,
                                    animationDuration:
                                        Duration(milliseconds: 800),
                                    colorList: [
                                      color1,
                                      Colors.black,
                                    ],
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 5,
                                    chartValueBackgroundColor:
                                        Colors.transparent,
                                    decimalPlaces: 1,
                                    showLegends: false,
                                    showChartValueLabel: true,
                                    initialAngle: 180,
                                    chartValueStyle: defaultChartValueStyle
                                        .copyWith(color: Colors.transparent),
                                    chartType: ChartType.ring,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.navigate_next),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
