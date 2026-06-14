import 'package:deebee_user/database/exercise_db_helper.dart';

class ExerciseDbRepository {
  // Panggil instance DBHelper
  final ExerciseDbHelper _dbHelper = ExerciseDbHelper();

  // Function menjalankan query input SQL
  Future<List<Map<String, dynamic>>> executeUserQuery(String query) async {
    final db = await _dbHelper.database;

    // Menggunakan rawQuery karena kueri SQL diketik dinamis oleh user
    return await db.rawQuery(query);
  }
}
