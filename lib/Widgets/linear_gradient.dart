import 'package:flutter/material.dart';

// List<Color> colors = [
//   Color.fromRGBO(13, 50, 77, 100),
//   Color.fromRGBO(0, 0, 10, 10)
// ];
LinearGradient gradient() {
  return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromRGBO(13, 50, 77, 100), Color.fromRGBO(0, 0, 10, 10)]);
}
