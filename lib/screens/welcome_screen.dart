import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitask/api.dart';
import 'package:vitask/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:vitask/database/StudentModel.dart';
import 'package:vitask/database/Student_DAO.dart';

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
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage("images/side.jpg"), fit: BoxFit.cover),
          ),
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeAnimatedTextKit(
                  text: ['VITask'],
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
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    regNo = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
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
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Password'),
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
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
//                      regNo = '18BLC1082';
//                      password = 'St.franciscollege1';
                        url =
                            'https://vitask.me/authenticate?username=18BLC1082&password=St.franciscollege1';
                        API api = API();
                        Map<String, dynamic> profileData =
                            await api.getAPIData(url);
                        String t = profileData['APItoken'];
                        String u = profileData['RegNo'].toString();
                        print(u);
                        Student student =
                            Student(regNo: u, profile: profileData);
                        //StudentDao().insertStudent(student);
                        StudentDao().delete(student);
                        print('Profile');
//                        Map<String, dynamic> attendanceData =
//                            await api.getAPIData(
//                                'https://vitask.me/classesapi?token=$t');
//                        print('Classes');
//                        Map<String, dynamic> timetableData =
//                            await api.getAPIData(
//                                'https://vitask.me/timetableapi?token=$t');
//                        print('Time Table');
//                        Map<String, dynamic> marksData = await api
//                            .getAPIData('https://vitask.me/marksapi?token=$t');
//                        print('Marks');
//                        Map<String, dynamic> acadhistoryData =
//                            await api.getAPIData(
//                                'https://vitask.me/acadhistoryapi?token=$t');
//                        print('ACadHistory');
//                      Map<String, dynamic> moodleData =
//                          await moodle.getAPIData('https://vitask.me/moodleapi?token=$t');
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) =>
//                                MenuDashboardPage(profileData),
//                          ),
//                        );
                        setState(() {
                          showSpinner = false;
                        });
//                        print(profileData['APItoken']);
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
                  Future<List<Student>> i = StudentDao().getAllStudents();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
