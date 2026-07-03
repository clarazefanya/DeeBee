import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/enums/type_enum_model.dart';
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

  // CREATE level (intro maupun gameplay)
  Future<int> createLevel({
    required int chapterId,
    required LevelType levelType,
  }) async {
    final db = await DBHelper().database;

    return await db.insert('levels', {
      'level_type': levelType.value,
      'note': null,
      'chapter_id': chapterId,
    });
  }

  // UPDATE note level
  Future<int> updateLevelNote({required int levelId, String? note}) async {
    final db = await DBHelper().database;

    return await db.update(
      'levels',
      {'note': note},
      where: 'id = ?',
      whereArgs: [levelId],
    );
  }

  // DELETE level
  Future<int> deleteLevel(int levelId) async {
    final db = await DBHelper().database;

    return await db.delete('levels', where: 'id = ?', whereArgs: [levelId]);
  }
}
