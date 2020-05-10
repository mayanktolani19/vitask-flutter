class Marksheet {
  String subject;

  var group;
  String exam;

  Marksheet({
    this.subject,
    this.group,
  });
}

class Exam {
  String exname;
  var val;
  Exam({this.exname, this.val});
}
