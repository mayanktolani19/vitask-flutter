class Student {
  String? profileKey;
  String? timeTableKey;
  String? attendanceKey;
  String? marksKey;
  String? acadHistoryKey;
  Map<String, dynamic>? profile;
  Map<String, dynamic>? timeTable;
  Map<String, dynamic>? attendance;
  Map<String, dynamic>? marks;
  Map<String, dynamic>? acadHistory;

  Student(
      {this.profileKey,
      this.profile,
      this.timeTableKey,
      this.timeTable,
      this.attendanceKey,
      this.attendance,
      this.marksKey,
      this.marks,
      this.acadHistoryKey,
      this.acadHistory});
}
