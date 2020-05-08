import 'package:flutter/foundation.dart';

class DayList {
  var day;
  var list;

  DayList({
    this.day,
    this.list,
  });
}

class Info {
  var codes;
  var loc;
  var courseName;
  var endTime;
  var startTime;
  var slot;
  var attendance;

  Info(
      {this.codes,
      this.loc,
      this.courseName,
      this.endTime,
      this.startTime,
      this.slot,
      this.attendance});
}
