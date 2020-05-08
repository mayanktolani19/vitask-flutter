import 'package:flutter/material.dart';
import 'tt.dart';
import 'package:vitask/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TimeTable extends StatefulWidget {
  TimeTable(this.timeTableData, this.attendanceData);
  final Map<String, dynamic> timeTableData;
  final Map<String, dynamic> attendanceData;

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<String> days;
  List<dynamic> daylist;

  List<DayList> dayele = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    daylist = [];
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
    for (var i = 0; i < days.length; i++) {
      daylist.add(widget.timeTableData["Timetable"][days[i]]);
    }
    dayele = [];
    var num = 0;
    while (num < days.length) {
      dayele.add(DayList(day: days[num], list: daylist[num]));
      num++;
    }
  }

  Widget marlist() {
    return Column(
      children: dayele.map((mr) {
        return Container(
          width: double.infinity,
          child:
              //main card
              Card(
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              child: Card(
                //color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Texts(mr.day, 18),
                    ),
                    Container(
                        width: double.infinity,
                        //padding: EdgeInsets.all(15.0),
                        child: minimar(mr.list)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget minimar(List<dynamic> list) {
    var codes = [];
    var loc = [];
    var courseName = [];
    var endTime = [];
    var startTime = [];
    var slot = [];
    var attendance = [];
    List<Info> exeele = [];

    var num = 0;

    while (num < list.length) {
      codes.add(list[num]["code"]);
      loc.add(list[num]["class"]);
      courseName.add(list[num]["courseName"]);
      endTime.add(list[num]["endTime"]);
      startTime.add(list[num]["startTime"]);
      slot.add(list[num]["slot"]);
      for (var i = 0; i < widget.attendanceData["Attended"].length; i++) {
        if (widget.attendanceData["Attended"][i]["courseName"] ==
            list[num]["courseName"]) {
          attendance.add(
              widget.attendanceData["Attended"][i]["percentage"].toString());
          break;
        }
      }
      num++;
    }
    var n = 0;
    while (n < attendance.length) {
      exeele.add(Info(
          codes: codes[n],
          courseName: courseName[n],
          endTime: endTime[n],
          loc: loc[n],
          slot: slot[n],
          startTime: startTime[n],
          attendance: attendance[n]));
      n++;
    }

    return Container(
        child: SingleChildScrollView(
            child: Column(
      children: exeele.map((e) {
        return Container(
          margin: EdgeInsets.all(7),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.blueAccent,
            ),
          ),
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.transparent,
                margin: EdgeInsets.all(4),
                elevation: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.codes + " - " + e.courseName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.clock,
                                    size: 17,
                                    color: Colors.lightBlue,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("${e.startTime} - ${e.endTime}",
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 20,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 10,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.tag,
                                      size: 17,
                                      color: Colors.lightBlue,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("${e.slot}",
                                          style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 20,
                                          )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      size: 18,
                                      color: Colors.lightBlue,
                                    ),
                                    ClipRect(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                              Color.fromRGBO(14, 14, 160, 10),
                                              Color.fromRGBO(31, 28, 24, 120)
                                            ])),
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 20,
                                          child: Center(
                                              child: Text(e.loc,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ))),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: LinearPercentIndicator(
                                animation: true,
                                width: MediaQuery.of(context).size.width / 1.4,
                                lineHeight: 15,
                                animationDuration: 900,
                                percent: double.parse(e.attendance) / 100,
                                backgroundColor: Colors.blue[300],
                                progressColor: Colors.blue[800],
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                center: Texts(e.attendance + "%", 15),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
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
              //centerTitle: true,
              backgroundColor: Colors.transparent,
              expandedHeight: 10,
              //centerTitle: true,
              floating: true,
              pinned: false,
              title: Text(
                "Timetable",
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                //height of the main box
                height: height,
                padding: EdgeInsets.all(9),

                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: dayele.map(
                    (mr) {
                      return Container(
                        width: width,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Texts(mr.day, 38),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              right: 10,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                height: height / 1.2,
                                width: width,
                                child: minimar(mr.list),
                              ),
                            ),
                          ],
                          overflow: Overflow.visible,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
