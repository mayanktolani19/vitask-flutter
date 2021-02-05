import 'package:flutter/material.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/constants.dart';
import 'package:vitask/screens/bunk_meter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  List<IconData> i = [FontAwesomeIcons.bookOpen, FontAwesomeIcons.laptopCode];
  int icon = 0;
  Map<String, dynamic> current;
  var attKeys;
  @override
  void initState() {
    super.initState();
    getAttended();
  }

  void getAttended() {
    attended = [];
    attKeys = widget.attendance["attendance"].keys.toList();
    for (var i = 0; i < widget.attendance["attendance"].length; i++)
      attended.add(widget.attendance["attendance"][attKeys[i]]);
    len = attended.length;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(gradient: gradient()),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Attendance'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: attended.isNotEmpty
              ? ListView.builder(
                  itemCount: len,
                  itemBuilder: (BuildContext context, int index) {
                    current = attended[index];
                    int p = current["percentage"];
                    var color1 = Colors.blue[800];
                    var color2 = Colors.blue[300];
                    if (p < 80 && p >= 75) {
                      color1 = Colors.yellow[900];
                      color2 = Colors.yellow[400];
                    } else if (p < 75) {
                      color1 = Colors.red[900];
                      color2 = Colors.red[300];
                    }
                    String c = current["courseName"];
                    int a = current["attended"];
                    int t = current["total"];
                    String ty = current["type"];
                    IconData iconUsed;
                    if (ty.contains("Theory") || ty.contains("Soft"))
                      iconUsed = i[0];
                    else
                      iconUsed = i[1];
                    var pie;
                    pie = double.parse(p.toString());
                    return Container(
                      margin: EdgeInsets.all(7),
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: color1,
                        ),
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
                          color: Colors.transparent,
                          elevation: 0,
                          margin: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Texts(c.toString(), 16),
                                        SizedBox(height: 4),
                                        Row(
                                          children: <Widget>[
                                            Texts(ty, 15),
                                            SizedBox(width: 8),
                                            Icon(iconUsed,
                                                size: 15, color: color1),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Texts(a.toString() + "/" + t.toString(),
                                            15),
                                      ],
                                    ),
                                  ),
                                  CircularPercentIndicator(
                                    radius: 90.0,
                                    lineWidth: 6.0,
                                    percent: double.parse(pie.toString()) / 100,
                                    center: Texts(p.toString() + "%", 16),
                                    progressColor: color1,
                                    backgroundColor: color2,
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.navigate_next),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Texts(
                            'Semester has just started, attendance will be updated soon',
                            16)),
                  ],
                ),
        ),
      ),
    );
  }
}
