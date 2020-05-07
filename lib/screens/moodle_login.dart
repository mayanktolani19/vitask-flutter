import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitask/api.dart';
import 'package:vitask/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vitask/database/MoodleModel.dart';
import 'package:vitask/database/Moodle_DAO.dart';
import 'moodle.dart';

class MoodleLogin extends StatefulWidget {
  MoodleLogin(this.regNo, this.appNo);
  String regNo;
  String appNo;
  @override
  _MoodleLoginState createState() => _MoodleLoginState();
}

class _MoodleLoginState extends State<MoodleLogin> {
  String regNo;
  String password;
  String url;
  String profile;
  bool showSpinner = false;
  var appNo1;
  var a;
  @override
  void initState() {
    super.initState();
    appNo1 = [];
    appNo1.add(widget.appNo);
    a = appNo1[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Color.fromRGBO(13, 50, 77, 100),
            Color.fromRGBO(0, 0, 10, 10)
          ])),
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
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecorationMoodle.copyWith(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your Password'),
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
                            setState(() {
                              showSpinner = true;
                            });
                            regNo = "18BLC1082";
                            password = "Fall@9264";
                            //print(widget.appNo);
//                            url =
//                                'https://vitask.me/moodleapi?username=18BLC1082&password=Fall@9264&appno=2018038483';
//                            print(a);
                            url =
                                "https://vitask.me/moodleapi?username=$regNo&password=$password&appno=$a";
                            API api = API();
                            Map<String, dynamic> moodleData =
                                await api.getAPIData(url);
                            if (moodleData != null) {
                              MoodleData m =
                                  MoodleData(regNo + "-moodle", moodleData);
                              MoodleDAO().deleteStudent(m);
                              MoodleDAO().insertMoodleData(m);
                              Map<String, dynamic> mod = await MoodleDAO()
                                  .getMoodleData(regNo + "-moodle");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Moodle(mod)));
                            }
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
