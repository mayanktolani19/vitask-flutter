import 'package:flutter/material.dart';

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
              child: Text(
                widget.profileData["RegNo"],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  //color: Colors.blue,
                  fontSize: 20,
                ),
              ),
            ),

//
            Positioned(
              left: 60,
              top: 220,
              child: Text(
                'Application Number: ' + widget.profileData["AppNo"],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
            ),
//

            Positioned(
              top: 250,
              left: 60,
              right: 60,
              child: Text(
                widget.profileData["Branch"],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                ),
              ),
            ),
//
//
            Positioned(
              top: 420,
              left: 35,
              child: Container(
                width: width / 1.2,
                height: 110,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.indigo,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Proctor',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                      ),
                    )),
              ),
            ),
//
            Positioned(
              left: 60,
              top: 470,
              child: Text(
                widget.profileData["ProctorName"],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                ),
              ),
            ),

            Positioned(
              left: 60,
              top: 490,
              child: Text(
                widget.profileData["ProctorEmail"],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 17,
                ),
              ),
            ),

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
