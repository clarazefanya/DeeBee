import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/chapter_model.dart';

class ChapterRepository {
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
}
