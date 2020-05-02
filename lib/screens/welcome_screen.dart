import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitask/api.dart';
import 'package:vitask/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vitask/database/StudentModel.dart';
import 'package:vitask/database/Student_DAO.dart';
import 'timetable.dart';

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
                        //Run this part to get the data from all the APIs and store it in the database.
                        // url =
                        //     'https://vitask.me/authenticate?username=18BLC1095&password=Durjanatoz2000';
                        // API api = API();
                        // Map<String, dynamic> profileData =
                        //     await api.getAPIData(url);
                        // String t = profileData['APItoken'].toString();
                        // String u = profileData['RegNo'].toString();
                        // Map<String, dynamic> attendanceData =
                        //     await api.getAPIData(
                        //         'https://vitask.me/classesapi?token=$t');
                        // print('Classes');
                        // Map<String, dynamic> timeTableData =
                        //     await api.getAPIData(
                        //         'https://vitask.me/timetableapi?token=$t');
                        // print('Time Table');
                        // Map<String, dynamic> marksData = await api
                        //     .getAPIData('https://vitask.me/marksapi?token=$t');
                        // print('Marks');
                        // Map<String, dynamic> acadHistoryData =
                        //     await api.getAPIData(
                        //         'https://vitask.me/acadhistoryapi?token=$t');
                        // print('AcadHistory');

                        // Student student = Student(
                        //     profileKey: (u + "-profile"),
                        //     profile: profileData,
                        //     attendanceKey: (u + "-attendance"),
                        //     attendance: attendanceData,
                        //     timeTableKey: (u + "-timeTable"),
                        //     timeTable: timeTableData,
                        //     marksKey: (u + "-marks"),
                        //     marks: marksData,
                        //     acadHistoryKey: (u + "-acadHistory"),
                        //     acadHistory: acadHistoryData);
                        // StudentDao().deleteStudent(student);
                        // StudentDao().insertStudent(student);
                        //Run this part for fetching the stored data from the database. Note the key value,i.e, "18BLC1082-profile, etc."
                        Map<String, dynamic> p =
                            (await StudentDao().getData("18BLC1082-profile"));
                        Map<String, dynamic> att = (await StudentDao()
                            .getData("18BLC1082-attendance"));
                        Map<String, dynamic> tt =
                            (await StudentDao().getData("18BLC1082-timeTable"));
                        Map<String, dynamic> m =
                            (await StudentDao().getData("18BLC1082-marks"));
                        Map<String, dynamic> ah = (await StudentDao()
                            .getData("18BLC1082-acadHistory"));
                        print(att);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MenuDashboardPage(p, att, tt, m, ah),
                          ),
                        );
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
                  Map<String, dynamic> tt =
                      (await StudentDao().getData("18BLC1095-timeTable"));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeTable(tt),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
