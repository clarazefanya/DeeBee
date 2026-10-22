import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/database/repository/firebase/user_scene_progress_repository_firebase.dart';
import 'package:deebee_user/models/user_model_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _progressRepo = UserSceneProgressRepositoryFirebase();

  // REGISTER (create user)
  Future<void> createUser(UserModelFirebase user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // LOGIN (get user by id)
  Future<UserModelFirebase?> getUserByUid(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      return null;
    }
    return UserModelFirebase.fromMap(doc.data()!);
  }

  // Update XP
  Future<void> addXp(String uid, int amount) async {
    await _firestore.collection('users').doc(uid).update({
      'xp': FieldValue.increment(amount),
    });
  }

  // Update lastSceneId
  Future<void> updateLastSceneId(String uid, String sceneId) async {
    await _firestore.collection('users').doc(uid).update({
      'lastSceneId': sceneId,
    });
  }

  // Update lastLevelId
  Future<void> updateLastLevelId(String uid, String levelId) async {
    await _firestore.collection('users').doc(uid).update({
      'lastLevelId': levelId,
    });
  }

  //ambil data leaderboard
  Future<List<UserModelFirebase>> getLeaderboard({int limit = 100}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'user')
          .orderBy('xp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => UserModelFirebase.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data leaderboard: $e');
    }
  }

  //delete akun user
  Future<void> deleteUserCascade(String uid) async {
    // hapus akun Firebase Auth
    await FirebaseAuth.instance.currentUser?.delete();
    // hapus semua progress milik user
    await _progressRepo.deleteProgressByUser(uid);
    // hapus dokumen user di Firestore
    await _firestore.collection('users').doc(uid).delete();
  }

  //update profile
  Future<void> updateProfile({
    required String uid,
    required String name,
    required int avatarIndex,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'avatarIndex': avatarIndex,
    });
  }

  //update user management
  Future<void> updateUser({
    required String uid,
    required String name,
    required String role,
    required bool isActive,
    required int avatarIndex,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'role': role,
      'isActive': isActive,
      'avatarIndex': avatarIndex,
    });
  }
}
