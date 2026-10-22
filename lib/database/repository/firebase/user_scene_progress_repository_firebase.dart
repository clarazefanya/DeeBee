import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/models/user_scene_progress_model_firebase.dart';

class UserSceneProgressRepositoryFirebase {
  final _collection = FirebaseFirestore.instance.collection(
    'user_scene_progress',
  );

  // CREATE
  Future<void> createProgress(UserSceneProgressModelFirebase progress) async {
    final docRef = _collection.doc();

    final newProgress = UserSceneProgressModelFirebase(
      id: docRef.id,
      userId: progress.userId,
      sceneId: progress.sceneId,
      isCompleted: progress.isCompleted,
      earnedXp: progress.earnedXp,
      completedAt: progress.completedAt,
    );

    await docRef.set(newProgress.toMap());
  }

  // READ satu progress user pada satu scene
  Future<UserSceneProgressModelFirebase?> getProgressByUserAndScene(
    String userId,
    String sceneId,
  ) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('sceneId', isEqualTo: sceneId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return UserSceneProgressModelFirebase.fromMap(snapshot.docs.first.data());
  }

  // READ semua progress milik user
  Future<List<UserSceneProgressModelFirebase>> getUserProgress(
    String userId,
  ) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();

    return snapshot.docs
        .map((doc) => UserSceneProgressModelFirebase.fromMap(doc.data()))
        .toList();
  }

  // UPDATE
  Future<void> updateProgress(UserSceneProgressModelFirebase progress) async {
    await _collection.doc(progress.id).update(progress.toMap());
  }

  // DELETE
  Future<void> deleteProgress(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> deleteProgressByUser(String userUid) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userUid)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Cek apakah scene sudah completed
  Future<bool> isSceneCompleted(String userId, String sceneId) async {
    final progress = await getProgressByUserAndScene(userId, sceneId);

    return progress?.isCompleted ?? false;
  }
}
