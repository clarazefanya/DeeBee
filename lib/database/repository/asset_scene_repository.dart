import 'package:deebee_user/database/db_helper.dart';
import 'package:deebee_user/models/asset_scene_model.dart';

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
    final db = await _dbHelper.database;

    return await db.delete('asset_scene', where: 'id = ?', whereArgs: [id]);
  }
}
