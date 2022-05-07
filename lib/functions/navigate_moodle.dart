import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitask/database/MoodleModel.dart';
import 'package:vitask/database/Moodle_DAO.dart';
import 'package:vitask/functions/test_internet.dart';
import 'package:vitask/screens/moodle.dart';
import 'package:vitask/screens/moodle_login.dart';
import '../api.dart';

void navigateMoodle(
    BuildContext context, Map<String, dynamic>? profileData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var moodlePassword = prefs.getString("moodle-password");
  if (moodlePassword == null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MoodleLogin(profileData!["RegNo"], profileData["APItoken"]),
      ),
    );
  } else {
    Map<String, dynamic>? moodleData =
        await MoodleDAO().getMoodleData(profileData!["RegNo"] + "-moodle");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Moodle(
          profileData["RegNo"],
          profileData["APItoken"],
          moodleData,
        ),
      ),
    );
  }
}

void getMoodleData(Map<String, dynamic> profileData) async {
  String? r = profileData["RegNo"];
  String? a = profileData["APItoken"];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var moodlePassword = prefs.getString("moodle-password");
  if(moodlePassword!=null){String url = "https://vitask.me/api/moodle/login";
  API api = API();
  Map<String, String?> data = {
    "username": r,
    "token": a,
    "password": moodlePassword
  };
  bool internet = await testInternet();
  if (internet) {
    Map<String, dynamic>? moodleData = await (api.getAPIData(url, data) as FutureOr<Map<String, dynamic>?>);
    if (moodleData != null) {
      MoodleData m = MoodleData(r! + "-moodle", moodleData);
      MoodleDAO().insertMoodleData(m);
    }
  }}

}
