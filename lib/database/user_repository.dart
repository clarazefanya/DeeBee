import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/models/user_model.dart';

import 'db_helper.dart';

class UserRepository {
  // Panggil instance DBHelper
  final DBHelper _dbHelper = DBHelper();

  // Register (CREATE)
  Future<bool> registerUser(UserModel pengguna) async {
    final db = await _dbHelper.database; // Ambil koneksi database

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
    final db = await _dbHelper.database;

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
    final db = await _dbHelper.database;
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

  // profil data user (READ)
  Future<UserModel?> getUserById(int id) async {
    final db = await _dbHelper.database;

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

  // TODO: Nanti fungsi login (READ), update profile (UPDATE),
  // dan banned user (DELETE/UPDATE) ditaruh di sini semua.
}
