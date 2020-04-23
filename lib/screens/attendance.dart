import 'package:flutter/material.dart';
import 'package:vitask/constants.dart';
import 'package:pie_chart/pie_chart.dart';

class Attendance extends StatefulWidget {
  Attendance(this.attendance);
  final Map<String, dynamic> attendance;

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  GlobalWidget k = GlobalWidget();
  static List<Map<String, dynamic>> attended;
  static int len;
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
            var current = attended[index];
            var p = current["percentage"];
            var c = current["courseName"];
            var a = current["attended"];
            var t = current["total"];
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Texts('$c', 20),
                          SizedBox(height: 4),
                          Texts('$a' + "/" + '$t', 16),
                        ],
                      ),
                    ),
                    Stack(
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
                          margin: EdgeInsets.only(top: 23, left: 11),
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
                          chartRadius: MediaQuery.of(context).size.width / 4.5,
                          //showChartValuesInPercentage: true,
//                        showChartValues: true,
//                      showChartValuesOutside: true,
                          chartValueBackgroundColor: Colors.transparent,
                          //legendPosition: LegendPosition.left,
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
                    SizedBox(width: 15),
                  ],
                ),
              ),
            );
          }),
    );
  }

//  static final makeListTile = ListTile(
//    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//    leading: Container(
//      padding: EdgeInsets.only(right: 12.0),
//      decoration: new BoxDecoration(
//          border: new Border(
//              right: new BorderSide(width: 1.0, color: Colors.white24))),
//      child: Icon(Icons.autorenew, color: Colors.white),
//    ),
//    title: Text(
//      '$len',
//      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//    ),
//    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
//
//    subtitle: Row(
//      children: <Widget>[
//        Icon(Icons.linear_scale, color: Colors.yellowAccent),
//        Text(" Intermediate", style: TextStyle(color: Colors.white))
//      ],
//    ),
//    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
//  );
//  Widget attCard(index){
//
//  }
}
