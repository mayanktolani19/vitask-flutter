import 'package:flutter/rendering.dart';

class Student {
  String regNo;
  Map<String, dynamic> profile;

  Student({
    this.regNo,
    this.profile,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        regNo: json["regNo"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "regNo": regNo,
        "profile": profile,
      };
}
