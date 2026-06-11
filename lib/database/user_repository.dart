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

    final semuaUser = await db.query('users');
    print('SEMUA USER:');
    print(semuaUser);

    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    print('EMAIL INPUT: $email');
    print('PASSWORD INPUT: $password');
    print('HASIL QUERY: ${results.length}');

    if (results.isNotEmpty) {
      // Mengembalikan UserModel semua kolom
      print(results.first);
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

  // Mengambil profil data user (READ)
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

  // Mengambil semua data user (READ)
  Future<List<UserModel>> getAllUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> results = await db.query('users');

    return results.map((map) => UserModel.fromMap(map)).toList();
  }

  // update user/profile (UPDATE)
  Future<int> updateUser(UserModel user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // delete user (DELETE)
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // TODO: Nanti fungsi login (READ), update profile (UPDATE),
  // dan banned user (DELETE/UPDATE) ditaruh di sini semua.
}
