import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/models/user_model_firebase.dart';

class UserRepositoryFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
