import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitask/api.dart';
import 'package:vitask/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vitask/database/StudentModel.dart';
import 'package:vitask/database/Student_DAO.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
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
                        fontSize: 45.0,
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
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          regNo = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          prefixIcon: Icon(
                            FontAwesomeIcons.userAlt,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          hintText: 'Enter your Registration No.',
                          errorText:
                              loginFail ? 'Invalid UserName or Password' : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: TextField(
                        obscureText: hidePassword,
                        textAlign: TextAlign.center,
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
                          hintText: 'Enter your Password',
                          errorText:
                              loginFail ? 'Invalid UserName or Password' : null,
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
                            setState(() {
                              showSpinner = true;
                            });
                            //Run this part to get the data from all the APIs and store it in the database.
                            regNo = regNo.trim();
                            url =
                                'https://vitask.me/authenticate?username=$regNo&password=$password';
                            API api = API();
                            Map<String, dynamic> profileData =
                                await api.getAPIData(url);
                            if (profileData != null &&
                                profileData["Error"] == null &&
                                regNo.length == 9) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  "regNo", profileData["RegNo"]);
                              await prefs.setString("password", password);
                              String t = profileData['APItoken'].toString();
                              String u = profileData['RegNo'].toString();
                              Map<String, dynamic> attendanceData =
                                  await api.getAPIData(
                                      'https://vitask.me/classesapi?token=$t');
                              print('Classes');
                              Map<String, dynamic> timeTableData =
                                  await api.getAPIData(
                                      'https://vitask.me/timetableapi?token=$t');
                              print('Time Table');
                              Map<String, dynamic> marksData =
                                  await api.getAPIData(
                                      'https://vitask.me/marksapi?token=$t');
                              print('Marks');
                              Map<String, dynamic> acadHistoryData =
                                  await api.getAPIData(
                                      'https://vitask.me/acadhistoryapi?token=$t');
                              print('AcadHistory');
                              if (attendanceData != null &&
                                  timeTableData != null &&
                                  marksData != null &&
                                  acadHistoryData != null) {
                                x = 1;
                                Student student = Student(
                                    profileKey: (u + "-profile"),
                                    profile: profileData,
                                    attendanceKey: (u + "-attendance"),
                                    attendance: attendanceData,
                                    timeTableKey: (u + "-timeTable"),
                                    timeTable: timeTableData,
                                    marksKey: (u + "-marks"),
                                    marks: marksData,
                                    acadHistoryKey: (u + "-acadHistory"),
                                    acadHistory: acadHistoryData);
                                StudentDao().deleteStudent(student);
                                StudentDao().insertStudent(student);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MenuDashboardPage(
                                                profileData,
                                                attendanceData,
                                                timeTableData,
                                                marksData,
                                                acadHistoryData,
                                                password)));
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } else {
                              setState(() {
                                loginFail = true;
                                showSpinner = false;
                              });
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
