import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/module_model.dart';

class ModuleRepository {
  // Mengambil data modul (READ)
  Future<List<ModuleModel>> getModules() async {
    final db = await DBHelper().database;

    final result = await db.query(
      'modules',
      where: 'is_published = ?',
      whereArgs: [1],
      orderBy: 'id ASC',
    );

    return result.map((e) => ModuleModel.fromMap(e)).toList();
  }
}
