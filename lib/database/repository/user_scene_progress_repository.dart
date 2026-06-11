import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/user_scene_progress_model.dart';

class UserSceneProgressRepository {
  // create progress?
  Future<int> createProgress(UserSceneProgressModel progress) async {
    final db = await DBHelper().database;

    return await db.insert('user_scene_progress', progress.toMap());
  }

  // Read progress satu scene milik user (READ)
  // Scene ini sudah pernah diselesaikan?
  Future<UserSceneProgressModel?> getProgressByUserAndScene(
    int userId,
    int sceneId,
  ) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'user_scene_progress',
      where: 'user_id = ? AND scene_id = ?',
      whereArgs: [userId, sceneId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserSceneProgressModel.fromMap(result.first);
  }

  // Read semua progress user (READ)
  Future<List<UserSceneProgressModel>> getUserProgress(int userId) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'user_scene_progress',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((e) => UserSceneProgressModel.fromMap(e)).toList();
  }

  // Update progress (UPDATE)
  Future<int> updateProgress(UserSceneProgressModel progress) async {
    final db = await DBHelper().database;

    return await db.update(
      'user_scene_progress',
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  // Delete progress (DELETE)
  Future<int> deleteProgress(int id) async {
    final db = await DBHelper().database;

    return await db.delete(
      'user_scene_progress',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
