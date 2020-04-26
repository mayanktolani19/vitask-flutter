import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:vitask/api.dart';
import 'package:vitask/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:vitask/database/StudentModel.dart';
import 'package:vitask/database/Student_DAO.dart';

class MoodleLogin extends StatefulWidget {
  @override
  _MoodleLoginState createState() => _MoodleLoginState();
}

class _MoodleLoginState extends State<MoodleLogin> {
  String regNo;
  String password;
  String url;
  String profile;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100,
                  child: Image.asset(
                    'images/icon1.png',
                  ),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    regNo = value;
                  },
                  decoration: kTextFieldDecorationMoodle.copyWith(
                      hintText: 'Enter your Registration No.'),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecorationMoodle.copyWith(
                      hintText: 'Enter your Password'),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    elevation: 5.0,
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(onPressed: () async {
                  Map<String, dynamic> hi =
                      (await StudentDao().getData("18BLC1083-marks"));
                  print(hi["Marks"]);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
