import 'package:flutter/material.dart';
import 'package:vitask/constants.dart';

class Profile extends StatefulWidget {
  Profile(this.cgpa, this.profileData);
  final String cgpa;
  final Map<String, dynamic> profileData;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(13, 50, 77, 100),
              Color.fromRGBO(0, 0, 10, 10)
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Profile'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 150,
                left: width / 40,
                right: width / 40,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.profileData["Name"],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Texts(widget.profileData["RegNo"], 20),
                      SizedBox(
                        height: 10,
                      ),
                      Texts(
                          'Application Number: ' + widget.profileData["AppNo"],
                          18),
                      SizedBox(
                        height: 10,
                      ),
                      Texts(widget.profileData["Branch"], 16),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: height / 1.8,
                left: 35,
                child: SingleChildScrollView(
                  child: Container(
                    width: width / 1.2,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.indigo,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topCenter,
                              child: Texts('Proctor Information', 22)),
                          SizedBox(height: 10),
                          Texts("Name - " + widget.profileData["ProctorName"],
                              16),
                          SizedBox(height: 10),
                          Texts("Email - " + widget.profileData["ProctorEmail"],
                              16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
//

//
              Positioned(
                bottom: 69,
                left: width / 9,
                child: Text(
                  widget.profileData["School"],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 23,
                  ),
                ),
              ),

              ///
              ///
              ///
              ///
              Positioned(
                top: height / 2.3,
                left: width / 3.2,
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.indigo,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    "CGPA : " + widget.cgpa,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      color: Colors.greenAccent,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),

              ///
              ///
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/blue.png',
                ),
              ),

              ///
            ],
          ),
        ),
      ),
    );
  }
}
