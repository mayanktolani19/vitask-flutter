import 'package:flutter/material.dart';
import 'tt.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class TimeTable extends StatefulWidget {
  TimeTable(this.timeTableData);
  final Map<String, dynamic> timeTableData;

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
    days = widget.timeTableData["Timetable"].keys.toList();
    daylist = widget.timeTableData["Timetable"].values.toList();

    dayele = [];
    var num = 0;
    while (num < days.length) {
      dayele.add(DayList(day: days[num], list: daylist[num]));
      num++;
    }
    print(dayele[0]);
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
                      child: Text(mr.day,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromRGBO(236, 150, 150, 3))),
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
    List<Info> exeele = [];

    var num = 0;

    while (num < list.length) {
      codes.add(list[num]["code"]);
      loc.add(list[num]["class"]);
      courseName.add(list[num]["courseName"]);
      endTime.add(list[num]["endTime"]);
      startTime.add(list[num]["startTime"]);
      slot.add(list[num]["slot"]);
      num++;
    }
    var n = 0;
    while (n < codes.length) {
      exeele.add(Info(
          codes: codes[n],
          courseName: courseName[n],
          endTime: endTime[n],
          loc: loc[n],
          slot: slot[n],
          startTime: startTime[n]));
      n++;
    }

    return Container(
        color: Colors.transparent,
        child: SingleChildScrollView(
            child: Column(
          children: exeele.map((e) {
            return Container(
              child: Column(
                children: <Widget>[
                  Card(
                    //individial card color
                    color: Colors.transparent,
                    elevation: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        //color: Colors.amber,
                        padding: EdgeInsets.symmetric(vertical: 10),

                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      e.courseName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 23,
                                        color: Colors.greenAccent[400],
                                        //Color.fromRGBO(152, 255, 152, 60),
                                      ),
                                    ),
                                  ],
                                ),
                                Card(
                                  color: Colors.transparent,
                                  elevation: 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(e.codes,
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      Container(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            " :  ${e.startTime}  --  ${e.endTime}",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            //loc
                            Positioned(
                              left: 300,
                              right: 0,
                              bottom: 0,
                              child: ClipRect(
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                        Color.fromRGBO(142, 14, 30, 10),
                                        Color.fromRGBO(31, 28, 24, 120)
                                      ])),
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 20,
                                    child: Center(
                                        child: Text(e.loc,
                                            style: TextStyle(
                                              fontSize: 17,
                                            ))),
                                  ),
                                ),
                              ),
                            ),

                            //loc end
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
              centerTitle: true,
              floating: true,
              pinned: false,
              title: Text(
                "timetable",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
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
                                child: Text(
                                  mr.day,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 50,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
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
