import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:vitask/screens/welcome_screen.dart';

void logoutUser(BuildContext context,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs?.clear();
  await flutterLocalNotificationsPlugin.cancelAll();
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (Route<dynamic> route) => false);
}
