import 'package:sembast/sembast.dart';
import 'StudentModel.dart';
import 'database_setup.dart';

class StudentDao {
  static const String folderName = "Students";
  final _studentFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  void insertStudent(Student student) async {
    //print(student);
    await _studentFolder.add(await _db, student.toJson());
    print('Student Inserted successfully !!');
  }

//  Future updateStudent(Student student) async{
//    final finder = Finder(filter: Filter.byKey(student.regNo));
//    await _studentFolder.update(await _db, student.toJson(),finder: finder);
//
//  }
//
//
  Future delete(Student student) async {
    final finder = Finder(filter: Filter.byKey(student.regNo));
    await _studentFolder.delete(await _db, finder: finder);
  }

//
  Future<List<Student>> getAllStudents() async {
    final recordSnapshot = await _studentFolder.find(await _db);
    return recordSnapshot.map((snapshot) {
      print(snapshot["profile"]["APItoken"]);
      final student = Student.fromJson(snapshot.value);
      return student;
    }).toList();
  }
}
