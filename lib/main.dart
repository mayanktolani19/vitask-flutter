import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:vitask/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Vitask());

class Vitask extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // hi();
    return KeyboardDismissOnTap(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VITask',
        theme: ThemeData.dark(),
        home: SplashScreen(),
      ),
    );
  }

  // void hi() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.clear();
  // }
}
