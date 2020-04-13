import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(Vitask());

class Vitask extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VITask',
      theme: ThemeData.dark(),
      home: WelcomeScreen(),
//      routes: {
//        'welcome_screen': (context) => WelcomeScreen(),
//        'CustomPainterDemo': (context) => CustomPaintDemo(),
//        'custom_dropdown': (context) => CustomDropdown(),
//      },
    );
  }
}
