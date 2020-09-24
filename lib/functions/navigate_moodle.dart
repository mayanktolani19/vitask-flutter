import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/database/Moodle_DAO.dart';
import 'package:vitask/screens/moodle.dart';
import 'package:vitask/screens/moodle_login.dart';

void navigateMoodle(
    BuildContext context, Map<String, dynamic> profileData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var moodlePassword = prefs.getString("moodle-password");
  if (moodlePassword == null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MoodleLogin(profileData["RegNo"], profileData["APItoken"]),
      ),
    );
  } else {
    Map<String, dynamic> mod =
        await MoodleDAO().getMoodleData(profileData["RegNo"] + "-moodle");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Moodle(
          profileData["RegNo"],
          profileData["APItoken"],
          mod,
        ),
      ),
    );
  }
}
