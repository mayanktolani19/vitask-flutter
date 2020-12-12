import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitask/Widgets/show_toast.dart';
import 'package:vitask/api.dart';
import 'package:vitask/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/functions/test_internet.dart';
import 'splash_screen2.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String regNo;
  String password;
  String url;
  String profile;
  bool showSpinner = false;
  bool loginFail = false;
  bool hidePassword = true;
  var passwordIcon = [FontAwesomeIcons.eyeSlash, FontAwesomeIcons.eye];
  var c = 0;
  int x = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(13, 35, 140, 70),
                  Color.fromRGBO(12, 10, 10, 10)
                ])),
            padding: EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimatedTextKit(
                      text: ['VITask Lite'],
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Image.asset('images/blue.png'),
                      height: 60.0,
                    ),
                    SizedBox(height: 18),
                    Container(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) {
                          regNo = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          prefixIcon: Icon(
                            FontAwesomeIcons.userAlt,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          labelText: 'Reg No',
                          labelStyle: TextStyle(color: Colors.white54),
                          errorText: loginFail
                              ? 'Invalid Registration No. or Password'
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: TextField(
                        obscureText: hidePassword,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          prefixIcon: Icon(FontAwesomeIcons.lock,
                              color: Colors.redAccent, size: 18),
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
                            color: Colors.redAccent,
                            iconSize: 19,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white54),
                          errorText: loginFail
                              ? 'Invalid Registration No. or Password'
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.red[100],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          onPressed: () async {
                            if (regNo != null) regNo = regNo.trim();
                            url = 'http://134.209.150.24/api/gettoken';
                            API api = API();
                            Map<String, String> data = {
                              "username": regNo,
                              "password": password
                            };
                            bool internet = await testInternet();
                            if (internet) {
                              setState(() {
                                showSpinner = true;
                              });
                              Map<String, dynamic> profileData =
                                  await api.getAPIData(url, data);
                              if (profileData != null &&
                                  profileData["error"] == null) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    "regNo", profileData["RegNo"]);
                                await prefs.setString("password", password);
                                print("Login");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SplashScreen2(
                                                password, profileData)));
                              } else {
                                setState(() {
                                  loginFail = true;
                                });
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } else {
                              showToast('Connection failed!', Colors.redAccent);
                            }
                          },
                          minWidth: 200.0,
                          height: 42.0,
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
    );
  }
}
