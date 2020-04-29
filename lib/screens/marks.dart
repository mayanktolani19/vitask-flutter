import 'package:flutter/material.dart';
import 'marksheet.dart';

class Marks extends StatefulWidget {
  Marks(this.marks);
  final Map<String, dynamic> marks;
  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  List<String> courses;
  List<dynamic> mark;

  List<Marksheet> marele = [];
  List<Exam> exeele = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  // void getData() {
  //   m = [];
  //   courses = widget.marks["Marks"].keys.toList();
  //   mark = widget.marks["Marks"].values.toList();
  //   for (var i = 0; i < widget.marks["Marks"].length; i++) {
  //     m.add(widget.marks["Marks"][i]);
  //   }
  //   print(widget.marks);
  //   //print(courses);
  //   //print(mark);
  //   //print(m);
  // }

  void getData() {
    courses = widget.marks["Marks"].keys.toList();
    mark = widget.marks["Marks"].values.toList();
    // print(widget.marks["Marks"].values.toList()[0]);
    // acad.forEach((k, v) => courses.add(
    //       k,
    //     ));

    //print(mark);
    marele = [];
    var num = 0;
    while (num < courses.length) {
      marele.add(Marksheet(subject: courses[num], group: mark[num]));
      num++;
    }
  }

  Widget marlist() {
    return Container(
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
          children: marele.map((mr) {
            return Container(
              width: double.infinity,
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //       begin: Alignment.topRight,
                    //       end: Alignment.bottomLeft,
                    //       colors: [
                    //         // Color.fromRGBO(229, 45, 39, 100),
                    //         // Color.fromRGBO(179, 18, 23, 100),
                    //         Colors.blue[900],
                    //         Colors.indigo,
                    //       ]),
                    // ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(0),
                            // gradient: LinearGradient(
                            //     begin: Alignment.topRight,
                            //     end: Alignment.bottomLeft,
                            //     colors: [
                            //       // Color.fromRGBO(229, 45, 39, 100),
                            //       // Color.fromRGBO(179, 18, 23, 100),
                            //       Colors.blue[900],
                            //       Colors.indigo,
                            //     ]),
                            boxShadow: [
                          BoxShadow(
                            color: Colors.indigo,
                            blurRadius: 3,
                            spreadRadius: 0.3,
                          ),
                        ]),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Text(mr.subject,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.0),
                              // decoration: BoxDecoration(
                              //   gradient: LinearGradient(
                              //       begin: Alignment.topRight,
                              //       end: Alignment.bottomLeft,
                              //       colors: [
                              //         Color.fromRGBO(229, 45, 39, 100),
                              //         Color.fromRGBO(179, 18, 23, 100),

                              //         // Colors.deepPurpleAccent,
                              //         // Colors.pinkAccent
                              //       ]),
                              //   borderRadius: BorderRadius.circular(7.0),
                              // ),
                              child: minimar(mr.group)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )));
  }

  Widget minimar(var group) {
    List<dynamic> examnames = [];
    List<dynamic> examvalues = [];
    List<Exam> exeele = [];
    group.forEach((k, v) => examnames.add(k));

    group.forEach((k, v) => examvalues.add(v));

    var num = 0;
    while (num < examnames.length) {
      exeele.add(Exam(exname: examnames[num], val: examvalues[num]));
      num++;
    }

    return Container(
        color: Colors.black,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(
          children: exeele.map((e) {
            return Container(
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(e.exname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        ClipOval(
                          child: Container(
                            width: 40,
                            height: 40,
                            //color: Color.fromRGBO(450, 0, 0, 5),
                            color: Colors.indigo,
                            child: Container(
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Center(
                                  child: Text(e.val,
                                      style: TextStyle(
                                        color: Colors.greenAccent[100],
                                        fontSize: 18,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            );
          }).toList(),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   titleSpacing: 61,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //         bottom: Radius.circular(20), top: Radius.circular(20)),
      //   ),
      //   title: Text('Marks'),
      //   backgroundColor: Color.fromRGBO(200, 25, 25, 60),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 90,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Marks",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Image.asset("images/side.jpg", fit: BoxFit.cover),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: marlist(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
