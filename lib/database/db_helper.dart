import 'package:deebee_user/database/db_tables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // db helper singleton
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // function panggil/init db
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'deebee.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 1. Eksekusi pembuatan tabel
        await db.execute(DBTables.createUsersTable);

        // Kalau nanti ada tabel baru, tinggal tambah di bawahnya:
        // await db.execute(DBTables.createProgressTable);

        // 2. Eksekusi insert data demo/dummy
        for (String query in DBTables.dummyDataQueries) {
          await db.execute(query);
        }
      },
    );
  }

  // // Fungsi Login GET
  // Future<UserModelSql?> loginUser(String email, String password) async {
  //   final db = await database;

  //   final List<Map<String, dynamic>> results = await db.query(
  //     'users',
  //     where: 'email = ? AND password = ?',
  //     whereArgs: [email, password],
  //   );
  //   log(results.toString());

  //   if (results.isNotEmpty) {
  //     return UserModelSql.fromMap(results.first);
  //   }
  //   return null;
  // }

  // // Fungsi untuk mengambil semua data user GET
  // Future<List<UserModelSql>> getAllUsers() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> results = await db.query('users');

  //   return results.map((map) => UserModelSql.fromMap(map)).toList();
  // }

  // // Fungsi untuk menghapus user berdasarkan ID
  // Future<void> deleteUser(int id) async {
  //   final db = await database;
  //   await db.delete('users', where: 'id = ?', whereArgs: [id]);
  // }

  // // Fungsi untuk memperbarui data user
  // Future<bool> updateUser(UserModelSql pengguna) async {
  //   final db = await database;
  //   try {
  //     int count = await db.update(
  //       'users',
  //       pengguna.toMap(),
  //       where: 'id = ?',
  //       whereArgs: [pengguna.id],
  //     );
  //     return count > 0;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
