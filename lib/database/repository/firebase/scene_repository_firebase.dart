import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/models/scene_model_firebase.dart';

class SceneRepositoryFirebase {
  final _collection = FirebaseFirestore.instance.collection('scenes');

  // CREATE
  Future<void> createScene(SceneModelFirebase scene) async {
    final docRef = _collection.doc();

    final existingScenes = await _collection
        .where('levelId', isEqualTo: scene.levelId)
        .get();
    final order = existingScenes.docs.length + 1;

    final newScene = SceneModelFirebase(
      id: docRef.id,
      sceneOrder: order,
      levelId: scene.levelId,
      bgImageId: scene.bgImageId,
      charImageId: scene.charImageId,
      charName: scene.charName,
      charDialog: scene.charDialog,
      sceneType: scene.sceneType,
      optionalSentence: scene.optionalSentence,
      question: scene.question,
      optionA: scene.optionA,
      optionB: scene.optionB,
      optionC: scene.optionC,
      answerKeyMultipleChoice: scene.answerKeyMultipleChoice,
      answerKey: scene.answerKey,
      rewardXp: scene.rewardXp,
    );

    await docRef.set(newScene.toMap());
  }

  // READ ALL BY LEVEL
  Future<List<SceneModelFirebase>> getScenesByLevel(String levelId) async {
    final snapshot = await _collection
        .where('levelId', isEqualTo: levelId)
        .orderBy('sceneOrder')
        .get();

    return snapshot.docs
        .map((doc) => SceneModelFirebase.fromMap(doc.data()))
        .toList();
  }

  // READ ONE
  Future<SceneModelFirebase?> getSceneById(String sceneId) async {
    final doc = await _collection.doc(sceneId).get();

    if (!doc.exists) return null;

    return SceneModelFirebase.fromMap(doc.data()!);
  }

  // UPDATE
  Future<void> updateScene(SceneModelFirebase scene) async {
    await _collection.doc(scene.id).update(scene.toMap());
  }

  // DELETE
  Future<void> deleteScene(String sceneId) async {
    await _collection.doc(sceneId).delete();
  }
}
