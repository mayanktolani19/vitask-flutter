import 'package:sembast/sembast.dart';
import 'MoodleModel.dart';
import 'database_setup.dart';

class MoodleDAO {
  var store = StoreRef.main();
  Future<Database> get _db async => await AppDatabase.instance.database;
  void insertMoodleData(MoodleData moodleData) async {
    await store
        .record(moodleData.moodleKey)
        .put(await _db, moodleData.moodleData);
  }

  Future<Map<String, dynamic>> getMoodleData(String key) async {
    var settings = await store.record(key).get(await _db) as Map;
    print(settings);
    return settings;
  }

  Future deleteStudent(MoodleData moodleData) async {
    await store.record(moodleData.moodleKey).delete(await _db);
  }
}
