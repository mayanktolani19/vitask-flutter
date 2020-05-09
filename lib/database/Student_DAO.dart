import 'package:sembast/sembast.dart';
import 'StudentModel.dart';
import 'database_setup.dart';

class StudentDao {
  var store = StoreRef.main();

  Future<Database> get _db async => await AppDatabase.instance.database;

  void insertStudent(Student student) async {
    await store.record(student.profileKey).put(await _db, student.profile);
    await store
        .record(student.attendanceKey)
        .put(await _db, student.attendance);
    await store.record(student.timeTableKey).put(await _db, student.timeTable);
    await store.record(student.marksKey).put(await _db, student.marks);
    await store
        .record(student.acadHistoryKey)
        .put(await _db, student.acadHistory);
    print('Student Inserted successfully !!');
  }

  Future<Map<String, dynamic>> getData(String key) async {
    var settings = await store.record(key).get(await _db) as Map;
    return settings;
    //print(finder);
  }

  Future deleteStudent(Student student) async {
    if (getData(student.marksKey) != null) {
      await store.record(student.profileKey).delete(await _db);
      await store.record(student.attendanceKey).delete(await _db);
      await store.record(student.timeTableKey).delete(await _db);
      await store.record(student.marksKey).delete(await _db);
      await store.record(student.acadHistoryKey).delete(await _db);
    }
  }
}
