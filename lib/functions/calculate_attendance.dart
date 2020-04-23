class CalculateAttendance {
  CalculateAttendance(this.att);
  var att;

  List<String> attendanceDetails() {
    att = att["Attended"];
    int attend = 0;
    int total = 0;
    List<String> a = [];
    for (var i = 0; i < att.length; i++) {
      attend = attend + (att[i]["attended"]);
      total = total + (att[i]["total"]);
    }

    a.add(total.toString());
    a.add(attend.toString());
    a.add((attend / total * 100).toStringAsFixed(2));
    //print(att["Attended"]);
    return a;
  }
}
