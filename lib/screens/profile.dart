import 'package:flutter/cupertino.dart';
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.profileData["Name"],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Texts(widget.profileData["RegNo"], 16),
                      SizedBox(
                        height: 10,
                      ),
                      Texts(
                          'Application Number: ' + widget.profileData["AppNo"],
                          16),
                      SizedBox(
                        height: 10,
                      ),
                      Texts(widget.profileData["Branch"], 15),
                      SizedBox(height: 10),
                      Texts(widget.profileData["School"], 15),
                      SizedBox(height: 10),
                      Texts("CGPA : " + widget.cgpa, 15),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey),
                      SizedBox(height: 10),
                      Texts(
                          "Proctor Name : " + widget.profileData["ProctorName"],
                          15),
                      SizedBox(height: 10),
                      Texts(
                          "Proctor Email : " +
                              widget.profileData["ProctorEmail"],
                          15),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/blue.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
