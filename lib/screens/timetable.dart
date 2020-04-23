import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitask/constants.dart';
import 'package:vitask/Widgets/pie_chart.dart';

//Widget cont() {
//  for (int i = 0; i < 3; i++) {
//    return Container(
//      child: Text("Hey"),
//    );
//  }
//}

class TimeScreen extends StatelessWidget {
  TimeScreen(this.data);
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            Material(
              //elevation: 5,
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(32)),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[900], Colors.grey[850]]),
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  color: Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[800],
                      offset: Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Colors.grey[900],
                      offset: Offset(-5.0, -5.0),
                      blurRadius: 20.0,
                      spreadRadius: 2.0,
                    )
                  ],
                ),
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          top: 10,
                          child: Text('$data["Timetable"]["Friday"][0][3]',
                              style: ktt.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 30)),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1),
                            child: ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text(
                                  '$data["Timetable"]["Friday"][0][1]' +
                                      "  " +
                                      '$data["Timetable"]["Friday"][0][2]',
                                  style: ktt),
                            ),
                          ),
                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: Padding(
//                            padding: EdgeInsets.only(bottom: 30),
//                            child: Row(
//                              children: <Widget>[
//                                CircleAvatar(
//                                  backgroundColor: Colors.green,
//                                  radius: 10,
//                                ),
//                                Text("Attendace percent")
//                              ],
//                            ),
//                          ),
//                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 100,
                            width: 100,
                            child: CustomPaint(
                                child: Center(
                                  child: Text("70 %", style: ktt),
                                ),
                                foregroundPainter: ProgressPainter(
                                    defaultCircleColor: Colors.red,
                                    percentageCompletedCircleColor:
                                        Colors.red[900],
                                    completedPercentage: 70.0,
                                    circleWidth: 30.0)),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: ListTile(
                                  leading: Icon(Icons.access_time),
                                  title: Text(
                                      '$data["Timetable"]["Friday"][0][4]' +
                                          " - " +
                                          '$data["Timetable"]["Friday"][0][5]',
                                      style: ktt)),
                            ))
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//mainAxisAlignment: MainAxisAlignment.start,
//children: <Widget>[
//
//Row(
//children: <Widget>[
//Expanded(
//child:
//Expanded(
//child:
//))
//],
//),
//
//],
//),
