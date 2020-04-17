import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:vitask/screens/classacad.dart';

class AcademicHistory extends StatefulWidget {
  AcademicHistory(this.acadHistory);
  Map<String, dynamic> acadHistory;
  @override
  _AcademicHistoryState createState() => _AcademicHistoryState();
}

class _AcademicHistoryState extends State<AcademicHistory> {
  Map<String, dynamic> acad;
  Map<String, dynamic> curriculum;
  List<String> courses = [];
  List<Text> numbers = [];
  List<String> grades = [];
  List<Acad> elements = [];

  @override
  void initState() {
    super.initState();
    printData();
    setState(() {
      courses.clear();
      numbers.clear();
    });
  }

  void printData() {
//    print(widget.acadHistory);
    acad = widget.acadHistory['AcadHistory'];
    curriculum = widget.acadHistory['CurriculumDetails'];
//    createLists();
  }

//  void createLists() {
//    acad.forEach((k, v) => courses.add(k));
//    print(courses);
//  }

Widget elelist(Map<String, dynamic> acad) {
    grades = [];
    acad.forEach((k, v) => grades.add(
          v
        ));
    courses = [];
    acad.forEach((k, v) => courses.add(
          k,
        ));
    elements=[];
    var num = 0;
    while (num < grades.length) {
      elements.add(Acad(subject: courses[num], grade: grades[num].toString()));
      num++;
    }
    
    return Container(
      width: double.infinity,
      child:  Column(
            
             crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: elements.map((tx) {
                    return 
                    Container(
                      
                      
                      child: Card(
                      
                      shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),),
                        //color: Color.fromRGBO(140, 47, 57, 100),
                        color:Colors.transparent,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 1,
                              horizontal: 0.001,
                            ),
                            padding:EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            
                            children: <Widget>[

                              Text(
                                    tx.subject,
                                    textScaleFactor: 1.04,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromRGBO(254, 208, 187,100),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  tx.grade,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:15,
                                    color: Color.fromRGBO(254, 208, 187,100),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  
                ),
      
      
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromRGBO(178, 58, 72, 100),
      
      appBar: AppBar(
        titleSpacing: 61,
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),),
        title: Text('Academic History'),
        backgroundColor:Color.fromRGBO(70, 18, 32 ,20),
      ),
      body: Container(
      
        child: Padding(
          
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: elelist(acad),
            ),
          ),
      ),
    );
  }

  
}
