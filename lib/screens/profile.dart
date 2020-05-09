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
    getData();
  }

  void getData() {
    print(widget.profileData);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
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
              left: 60,
              top: 150,
              right: 40,
              child: Text(
                widget.profileData["Name"],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                ),
              ),
            ),

            //
            Positioned(
              top: 190,
              left: 60,
              child: Texts(widget.profileData["RegNo"], 20),
            ),

//
            Positioned(
              left: 60,
              top: 220,
              child: Texts(
                  'Application Number: ' + widget.profileData["AppNo"], 19),
            ),
//

            Positioned(
              top: 250,
              left: 60,
              right: 60,
              child: Texts(widget.profileData["Branch"], 19),
            ),
//
//
            Positioned(
              top: 420,
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
                        SizedBox(height: 5),
                        Texts(
                            "Name - " + widget.profileData["ProctorName"], 19),
                        SizedBox(height: 5),
                        Texts("Email - " + widget.profileData["ProctorEmail"],
                            19),
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
              left: 40,
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
            Center(
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
    );
  }
}
