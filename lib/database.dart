import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

doStuff(String t, String p) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo2.db');

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db
        .execute('CREATE TABLE users(token TEXT PRIMARY KEY, profile TEXT)');
  });
  final Database db = database;

  await db.insert(
    'users',
    {'token': t, 'profile': p},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  List<Map> list = await database.rawQuery('SELECT * FROM users');

  print(list);
}
