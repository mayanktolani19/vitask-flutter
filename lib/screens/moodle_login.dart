import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/Widgets/linear_gradient.dart';
import 'package:vitask/Widgets/show_toast.dart';
import 'package:vitask/api.dart';
import 'package:vitask/constants.dart';
import 'package:vitask/database/MoodleModel.dart';
import 'package:vitask/database/Moodle_DAO.dart';
import 'package:vitask/functions/test_internet.dart';

import 'moodle.dart';

class MoodleLogin extends StatefulWidget {
  MoodleLogin(this.regNo, this.token);
  final String? regNo;
  final String? token;
  @override
  _MoodleLoginState createState() => _MoodleLoginState();
}

class _MoodleLoginState extends State<MoodleLogin> {
  String? password, url, profile;
  bool showSpinner = false, loginFail = false, hidePassword = true;
  var reg, a, c = 0;
  var passwordIcon = [FontAwesomeIcons.eyeSlash, FontAwesomeIcons.eye];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(gradient: gradient()),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Moodle'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SingleChildScrollView(
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
                      SizedBox(
                        height: 30.0,
                      ),
                      TextField(
                        obscureText: hidePassword,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kTextFieldDecorationMoodle.copyWith(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white54),
                          prefixIcon: Icon(FontAwesomeIcons.lock,
                              color: Colors.orangeAccent, size: 18),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                                if (c == 0)
                                  c = 1;
                                else
                                  c = 0;
                              });
                            },
                            icon: Icon(passwordIcon[c]),
                            color: Colors.orangeAccent,
                            iconSize: 19,
                          ),
                          errorText: loginFail ? 'Invalid Password' : null,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          elevation: 5.0,
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(30.0),
                          child: MaterialButton(
                            onPressed: () async {
                              bool internet = await testInternet();
                              if (internet) {
                                if (password!.isNotEmpty) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  reg = widget.regNo;
                                  a = widget.token;
                                  url = "https://vitask.me/api/moodle/login";
                                  API api = API();
                                  Map<String, String?> data = {
                                    "username": reg,
                                    "password": password,
                                    "token": a
                                  };
                                  Map<String, dynamic> moodleData =
                                      await (api.getAPIData(url!, data) as FutureOr<Map<String, dynamic>>);
                                  print(moodleData);
                                  if (moodleData.isNotEmpty &&
                                      moodleData['error'] == null) {
                                    MoodleData m =
                                        MoodleData(reg + "-moodle", moodleData);
                                    var h = MoodleDAO()
                                        .getMoodleData(reg + "-moodle");
                                    if (h != null) MoodleDAO().deleteStudent(m);
                                    MoodleDAO().insertMoodleData(m);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                        "moodle-password", password!);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Moodle(reg, a, moodleData)));
                                  } else {
                                    setState(() {
                                      loginFail = true;
                                    });
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else
                                  showToast(
                                      'Please provide a password', Colors.red);
                              } else {
                                showToast('Connection failed', Colors.red);
                              }
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
