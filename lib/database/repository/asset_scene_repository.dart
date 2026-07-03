import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/asset_scene_model.dart';
import 'package:sqflite/sqflite.dart';

class AssetSceneRepository {
  // Panggil instance DBHelper
  final DBHelper _dbHelper = DBHelper();

  // Upload image (CREATE)
  Future<int> createAssetScene(AssetSceneModel asset) async {
    final db = await _dbHelper.database;

    return await db.insert('asset_scene', asset.toMap());
  }

  // Read semua image berdasarkan category (READ)
  Future<List<AssetSceneModel>> getAssetSceneByCategory(String category) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'asset_scene',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'id DESC',
    );

    // print('===== ASSET SCENE =====');
    // for (final row in result) {
    //   print(row);
    // }

    return result.map((e) => AssetSceneModel.fromMap(e)).toList();
  }

  // Delete Image (DELETE)
  Future<int> deleteAssetScene(int id) async {
    final db = await DBHelper().database;

    try {
      return await db.delete('asset_scene', where: 'id = ?', whereArgs: [id]);
    } on DatabaseException catch (e) {
      if (e.toString().contains('FOREIGN KEY constraint failed')) {
        throw Exception('Asset sedang digunakan oleh scene.');
      }
      rethrow;
    }
  }

  // Read image berdasarkan id (READ)
  Future<AssetSceneModel> getAssetAssetById(int id) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'asset_scene',
      where: 'id = ?',
      whereArgs: [id],
    );

    return AssetSceneModel.fromMap(result.first);
  }

  // Update Nama Image (UPDATE)
  Future<int> updateImageName(int id, String newName) async {
    final db = await _dbHelper.database;

    return await db.update(
      'asset_scene',
      {'image_name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
