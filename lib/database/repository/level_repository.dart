import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/level_model.dart';

class LevelRepository {
  // dapatkan level dari chapter_id
  Future<List<LevelModel>> getLevelsByChapter(int chapterId) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'levels',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
      orderBy: 'id ASC',
    );

    return result.map((e) => LevelModel.fromMap(e)).toList();
  }

  // dapatkan level dari id
  Future<LevelModel?> getLevelById(int levelId) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'levels',
      where: 'id = ?',
      whereArgs: [levelId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return LevelModel.fromMap(result.first);
  }
}
