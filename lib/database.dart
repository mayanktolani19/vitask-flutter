import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

doStuff() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db
        .execute('CREATE TABLE users(id INTEGER PRIMARY KEY, profile TEXT)');
  });
  final Database db = database;

  await db.insert(
    'users',
    {'id': 2, 'profile': 'Divya'},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  List<Map> list = await database.rawQuery('SELECT * FROM users');

  print(list);
}
