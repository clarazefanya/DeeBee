import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/chapter_model.dart';
import 'package:deebee_user/models/enums/type_enum_model.dart';

class ChapterRepository {
  // dapatkan chapter dari module_id
  Future<List<ChapterModel>> getChaptersByModule(int moduleId) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'chapters',
      where: 'module_id = ?',
      whereArgs: [moduleId],
      orderBy: 'id ASC',
    );

    return result.map((e) => ChapterModel.fromMap(e)).toList();
  }

  // dapatkan chapter dari id nya
  Future<ChapterModel?> getChapterById(int chapterId) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'chapters',
      where: 'id = ?',
      whereArgs: [chapterId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return ChapterModel.fromMap(result.first);
  }

  // CREATE chapter
  Future<int> createChapter({
    required String chapterTitle,
    required String shortDesc,
    required String longDesc,
    required int moduleId,
  }) async {
    final db = await DBHelper().database;

    return await db.transaction((txn) async {
      // Insert chapter
      final chapterId = await txn.insert('chapters', {
        'chapter_title': chapterTitle,
        'short_desc': shortDesc,
        'long_desc': longDesc,
        'module_id': moduleId,
      });

      // Otomatis buat level intro
      await txn.insert('levels', {
        'level_type': LevelType.intro.value,
        'note': null,
        'chapter_id': chapterId,
      });

      return chapterId;
    });
  }

  // UPDATE chapter
  Future<int> updateChapter({
    required int chapterId,
    required String chapterTitle,
    required String shortDesc,
    required String longDesc,
  }) async {
    final db = await DBHelper().database;

    return await db.update(
      'chapters',
      {
        'chapter_title': chapterTitle,
        'short_desc': shortDesc,
        'long_desc': longDesc,
      },
      where: 'id = ?',
      whereArgs: [chapterId],
    );
  }

  // DELETE chapter
  Future<int> deleteChapter(int chapterId) async {
    final db = await DBHelper().database;

    return await db.delete('chapters', where: 'id = ?', whereArgs: [chapterId]);
  }
}
