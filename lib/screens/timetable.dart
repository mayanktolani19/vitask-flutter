import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/constants.dart';

import 'tt.dart';

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
  var attKeys;

  List<DayList> dayele = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    attKeys = widget.attendanceData["attendance"].keys.toList();
    daylist = [];
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
    for (var i = 0; i < days.length; i++) {
      daylist.add(widget.timeTableData["timetable"][days[i]]);
    }
    print(daylist[0]);
    dayele = [];
    var num = 0;
    while (num < days.length) {
      dayele.add(DayList(day: days[num], list: daylist[num]));
      num++;
    }
  }

  Widget minimar(List<dynamic> list) {
    var codes = [],
        loc = [],
        courseName = [],
        endTime = [],
        startTime = [],
        slot = [],
        attendance = [];
    List<Info> exeele = [];

    var num = 0;

    while (num < list.length) {
      codes.add(list[num]["code"]);
      loc.add(list[num]["class"]);
      courseName.add(list[num]["courseName"]);
      endTime.add(list[num]["endTime"]);
      startTime.add(list[num]["startTime"]);
      slot.add(list[num]["slot"]);

      for (var i = 0; i < widget.attendanceData["attendance"].length; i++) {
        var slot = list[num]["slot"];
        if (slot.contains("L")) {
          if (widget.attendanceData["attendance"][attKeys[i]]["courseName"] ==
                  list[num]["courseName"] &&
              (widget.attendanceData["attendance"][attKeys[i]]["type"]
                      .contains("Lab") ||
                  widget.attendanceData["attendance"][attKeys[i]]["type"]
                      .contains("Soft"))) {
            attendance.add(widget.attendanceData["attendance"][attKeys[i]]
                    ["percentage"]
                .toString());
            break;
          }
        } else {
          if (widget.attendanceData["attendance"][attKeys[i]]["courseName"] ==
                  list[num]["courseName"] &&
              (widget.attendanceData["attendance"][attKeys[i]]["type"]
                      .contains("Theory") ||
                  widget.attendanceData["attendance"][attKeys[i]]["type"]
                      .contains("Soft") ||
                  !widget.attendanceData["attendance"][attKeys[i]]["type"]
                      .contains("Lab"))) {
            attendance.add(widget.attendanceData["attendance"][attKeys[i]]
                    ["percentage"]
                .toString());
            break;
          }
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

    return SingleChildScrollView(
        child: Container(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: exeele.map((e) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          padding: EdgeInsets.all(9),
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
                                Texts(e.codes + " - " + e.courseName, 17),
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
                                    size: 16,
                                    color: Colors.lightBlue,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("${e.startTime} - ${e.endTime}",
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 16,
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
                                      size: 16,
                                      color: Colors.lightBlue,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("${e.slot}",
                                          style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      size: 16,
                                      color: Colors.lightBlue,
                                    ),
                                    ClipRect(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                              Color.fromRGBO(14, 14, 160, 10),
                                              Color.fromRGBO(0, 0, 20, 120)
                                            ])),
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 20,
                                          child: Center(
                                              child: Text(e.loc,
                                                  style: TextStyle(
                                                    color: Colors.lightBlue,
                                                    fontSize: 16,
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
                              padding:
                                  const EdgeInsets.only(top: 7.0, left: 20),
                              child: LinearPercentIndicator(
                                animation: true,
                                width: MediaQuery.of(context).size.width / 1.4,
                                lineHeight: 15,
                                animationDuration: 900,
                                percent: double.parse(e.attendance) / 100,
                                backgroundColor: Colors.blue[300],
                                progressColor: Colors.blue[800],
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                center: Texts(e.attendance + "%", 14),
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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = listView(context, dayele);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: gradient()),
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.all(9),
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('TimeTable'),
          backgroundColor: Color.fromRGBO(13, 50, 77, 100),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Color.fromRGBO(13, 50, 77, 100),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(4, 30, 53, 100),
              icon: Icon(FontAwesomeIcons.calendar),
              title: Text('Mon'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(4, 30, 53, 100),
              icon: Icon(FontAwesomeIcons.calendar),
              title: Text('Tue'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(4, 30, 53, 100),
              icon: Icon(FontAwesomeIcons.calendar),
              title: Text('Wed'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(4, 30, 53, 100),
              icon: Icon(FontAwesomeIcons.calendar),
              title: Text('Thu'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(4, 30, 53, 100),
              icon: Icon(FontAwesomeIcons.calendar),
              title: Text('Fri'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> listView(BuildContext context, List<DayList> dayele) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return dayele.map(
      (mr) {
        int labs = 0;
        int theory = 0;
        if (mr.list != null) {
          for (var i = 0; i < mr.list.length; i++) {
            if ((mr.list[i]["slot"]).contains("L")) {
              labs++;
            } else {
              theory++;
            }
          }
          labs = labs ~/ 2;
        }
        return Container(
          width: width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    mr.day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 33,
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 5),
                          child: Texts(theory.toString() + " Theory ", 15),
                        ),
                        Icon(
                          FontAwesomeIcons.bookOpen,
                          size: 16,
                          color: Colors.lightBlue,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Texts(
                                  "  |  " + labs.toString() + " Lab(s) ", 15),
                            ),
                            Icon(
                              FontAwesomeIcons.laptopCode,
                              size: 16,
                              color: Colors.lightBlue,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 41,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: height / 1.32,
                  width: width,
                  child: mr.list != null ? minimar(mr.list) : Container(),
                ),
              ),
            ],
            overflow: Overflow.visible,
          ),
        );
      },
    ).toList();
  }
}
