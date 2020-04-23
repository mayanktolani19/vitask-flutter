import 'package:flutter/material.dart';
import 'package:vitask/constants.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Attendance extends StatefulWidget {
  Attendance(this.attendance);
  final Map<String, dynamic> attendance;

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
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
//    attended = widget.attendance["Attended"];
    for (var i = 0; i < widget.attendance["Attended"].length; i++)
      attended.add(widget.attendance["Attended"][i]);
    len = attended.length;
    print(len);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            current = attended[index];
            int p = current["percentage"];
            String c = current["courseName"];
            int a = current["attended"];
            int t = current["total"];
//            var ty = current["type"].split;
            Map<String, double> pie = {};
            pie["Present"] = double.parse(p.toString());
            pie["Absent"] = 100 - double.parse(p.toString());
            return Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                //color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
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
                              Texts(c.toString(), 23),
                              SizedBox(height: 4),
                              Texts(a.toString() + "/" + t.toString(), 19),
                            ],
                          ),
                        ),
                        Expanded(
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
                                animationDuration: Duration(milliseconds: 800),
                                //chartLegendSpacing: 32.0,
                                //showChartValues: false,
                                colorList: [Colors.red, Colors.blueGrey],
                                chartRadius:
                                    MediaQuery.of(context).size.width / 4.5,
                                //showChartValuesInPercentage: true,
//                        showChartValues: true,
//                      showChartValuesOutside: true,
                                chartValueBackgroundColor: Colors.transparent,
                                //legendPosition: LegendPosition.left,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 10),
                        Center(
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.black26,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.minus),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  a--;
                                  t++;
                                  print(a);
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Center(
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.black,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.plus),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  a++;
                                  t++;
                                  print(a);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
