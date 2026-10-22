import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/models/asset_scene_model_firebase.dart';

class AssetSceneRepositoryFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE
  Future<void> createAssetScene(AssetSceneModelFirebase asset) async {
    await _firestore.collection('asset_scene').doc(asset.id).set(asset.toMap());
  }

  // READ berdasarkan kategori
  Future<List<AssetSceneModelFirebase>> getAssetSceneByCategory(
    String category,
  ) async {
    final snapshot = await _firestore
        .collection('asset_scene')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs
        .map((doc) => AssetSceneModelFirebase.fromMap(doc.data()))
        .toList();
  }

  Stream<List<AssetSceneModelFirebase>> streamAssetSceneByCategory(
    String category,
  ) {
    return _firestore
        .collection('asset_scene')
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AssetSceneModelFirebase.fromMap(doc.data()))
              .toList(),
        );
  }

  // READ berdasarkan id
  Future<AssetSceneModelFirebase?> getAssetById(String id) async {
    final doc = await _firestore.collection('asset_scene').doc(id).get();

    if (!doc.exists) return null;

    return AssetSceneModelFirebase.fromMap(doc.data()!);
  }

  // UPDATE nama image
  Future<void> updateImageName(String id, String newName) async {
    await _firestore.collection('asset_scene').doc(id).update({
      'imageName': newName,
    });
  }

  // DELETE
  Future<void> deleteAssetScene(String id) async {
    // cek apakah dipakai sebagai background/karakter
    final results = await Future.wait([
      _firestore
          .collection('scenes')
          .where('bgImageId', isEqualTo: id)
          .limit(1)
          .get(),
      _firestore
          .collection('scenes')
          .where('charImageId', isEqualTo: id)
          .limit(1)
          .get(),
    ]);

    if (results[0].docs.isNotEmpty || results[1].docs.isNotEmpty) {
      throw Exception('Asset sedang digunakan oleh scene.');
    }

    await _firestore.collection('asset_scene').doc(id).delete();
  }
}
