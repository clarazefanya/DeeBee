import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/scene_model.dart';

class SceneRepository {
  // Create scene (CREATE)
  Future<int> createScene(SceneModel scene) async {
    final db = await DBHelper().database;

    return await db.insert('scenes', scene.toMap());
  }

  // Ambil scene berdasarkan level (READ)
  Future<List<SceneModel>> getScenesByLevel(int levelId) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'scenes',
      where: 'level_id = ?',
      whereArgs: [levelId],
      orderBy: 'id ASC',
    );

    return result.map((e) => SceneModel.fromMap(e)).toList();
  }

  // Read one scene utk preview scene (READ)
  Future<SceneModel?> getSceneById(int id) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'scenes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return SceneModel.fromMap(result.first);
  }

  // Update scene (UPDATE)
  Future<int> updateScene(SceneModel scene) async {
    final db = await DBHelper().database;

    return await db.update(
      'scenes',
      scene.toMap(),
      where: 'id = ?',
      whereArgs: [scene.id],
    );
  }

  // Delete scene (DELETE)
  Future<int> deleteScene(int id) async {
    final db = await DBHelper().database;

    return await db.delete('scenes', where: 'id = ?', whereArgs: [id]);
  }
}
