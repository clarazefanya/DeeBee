import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/models/user_model.dart';

import '../db_helper.dart';

class UserRepository {
  // Register (CREATE)
  Future<bool> registerUser(UserModel pengguna) async {
    final db = await DBHelper().database; // Ambil koneksi database

    try {
      await db.insert('users', pengguna.toMap());
      return true;
    } catch (e) {
      print('Error Register: ${e.toString()}');
      return false;
    }
  }

  // Login (READ)
  Future<UserModel?> loginUser(String email, String password) async {
    final db = await DBHelper().database;

    // final semuaUser = await db.query('users');
    // print('SEMUA USER:');
    // print(semuaUser);

    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      // Mengembalikan UserModel semua kolom
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  // Mengambil XP user aktif (READ)
  Future<int> getUserXp() async {
    final db = await DBHelper().database;
    final int? currentUserId = PreferenceHandler.userId;

    if (currentUserId == null) return 0; // Jaga-jaga kalau belum login

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['xp'],
      where: 'id = ?',
      whereArgs: [currentUserId],
    );

    if (result.isNotEmpty) {
      return result.first['xp'] as int;
    }
    return 0;
  }

  // Mengambil profil data user (READ)
  Future<UserModel?> getUserById(int id) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  // Mengambil semua data user (READ)
  Future<List<UserModel>> getAllUsers() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> results = await db.query('users');

    return results.map((map) => UserModel.fromMap(map)).toList();
  }

  // update user/profile (UPDATE)
  Future<int> updateUser(UserModel user) async {
    final db = await DBHelper().database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // delete user (DELETE)
  Future<int> deleteUser(int id) async {
    final db = await DBHelper().database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // // Update XP user
  // Future<int> updateXp(int userId, int xp) async {
  //   final db = await DBHelper().database;

  //   return await db.update(
  //     'users',
  //     {'xp': xp},
  //     where: 'id = ?',
  //     whereArgs: [userId],
  //   );
  // }

  // Update XP user (langsung dijumlahkan sesuai xp yg didapat)
  Future<int> addXp(int userId, int amount) async {
    final db = await DBHelper().database;

    return await db.rawUpdate(
      '''
    UPDATE users
    SET xp = xp + ?
    WHERE id = ?
    ''',
      [amount, userId],
    );
  }

  // Update last scene user
  Future<int> updateLastSceneId(int userId, int sceneId) async {
    final db = await DBHelper().database;

    return await db.update(
      'users',
      {'last_scene_id': sceneId},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Update last level user
  Future<int> updateLastLevelId(int userId, int levelId) async {
    final db = await DBHelper().database;

    return await db.update(
      'users',
      {'last_level_id': levelId},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
