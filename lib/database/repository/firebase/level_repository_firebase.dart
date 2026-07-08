import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/database/repository/firebase/scene_repository_firebase.dart';
import 'package:deebee_user/models/enums/type_enum_model.dart';
import 'package:deebee_user/models/level_model_firebase.dart';

class LevelRepositoryFirebase {
  final _collection = FirebaseFirestore.instance.collection('levels');

  // utk delete on cascade
  final _sceneRepo = SceneRepositoryFirebase();

  // READ
  Future<List<LevelModelFirebase>> getLevelsByChapter(String chapterId) async {
    final snapshot = await _collection
        .where('chapterId', isEqualTo: chapterId)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((e) => LevelModelFirebase.fromMap(e.data()))
        .toList();
  }

  Stream<List<LevelModelFirebase>> streamLevelsByChapter(String chapterId) {
    return _collection
        .where('chapterId', isEqualTo: chapterId)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => LevelModelFirebase.fromMap(e.data()))
              .toList(),
        );
  }

  Future<LevelModelFirebase?> getLevelById(String levelId) async {
    final doc = await _collection.doc(levelId).get();

    if (!doc.exists) return null;

    return LevelModelFirebase.fromMap({'id': doc.id, ...doc.data()!});
  }

  // CREATE
  Future<void> createLevel({
    required String chapterId,
    required LevelType levelType,
  }) async {
    final id = _collection.doc().id;

    final snapshot = await _collection
        .where('chapterId', isEqualTo: chapterId)
        .get();

    final nextOrder = snapshot.docs.length;

    final level = LevelModelFirebase(
      id: id,
      chapterId: chapterId,
      levelType: levelType.value,
      note: null,
      order: nextOrder,
    );

    await _collection.doc(id).set(level.toMap());
  }

  // UPDATE
  Future<void> updateLevelNote({required String levelId, String? note}) async {
    await _collection.doc(levelId).update({'note': note});
  }

  // DELETE
  Future<void> deleteLevel(String levelId) async {
    await _collection.doc(levelId).delete();
  }

  // DELETE ON CASCADE LEVEL
  Future<void> deleteLevelCascade(String levelId) async {
    final scenes = await _sceneRepo.getScenesByLevel(levelId);

    for (final scene in scenes) {
      await _sceneRepo.deleteScene(scene.id);
    }

    await deleteLevel(levelId);
  }
}
