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

      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: (db, version) async {
        // 1. Eksekusi pembuatan tabel
        await db.execute(DBTables.createUsersTable);
        await db.execute(DBTables.createAssetSceneTable);
        await db.execute(DBTables.createModulesTable);
        await db.execute(DBTables.createChaptersTable);
        await db.execute(DBTables.createLevelsTable);
        await db.execute(DBTables.createScenesTable);
        await db.execute(DBTables.createScenesProgressTable);

        // 2. Eksekusi insert data demo/dummy
        // users
        for (final query in DBTables.dummyUserQueries) {
          await db.execute(query);
        }
        // assetscene
        await DBDummy.insertDummyAssetScene(db);
        // content
        for (final query in DBTables.dummyGameContentQueries) {
          await db.execute(query);
        }
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Hapus seluruh tabel selain users
          await db.execute('DROP TABLE IF EXISTS user_scene_progress');
          await db.execute('DROP TABLE IF EXISTS scenes');
          await db.execute('DROP TABLE IF EXISTS levels');
          await db.execute('DROP TABLE IF EXISTS chapters');
          await db.execute('DROP TABLE IF EXISTS modules');
          await db.execute('DROP TABLE IF EXISTS asset_scene');
          // Reset progress user
          await db.execute('''
            UPDATE users
            SET
            last_level_id = NULL,
            last_scene_id = NULL,
            xp = 0;
          ''');
          // Buat ulang tabel
          await db.execute(DBTables.createAssetSceneTable);
          await db.execute(DBTables.createModulesTable);
          await db.execute(DBTables.createChaptersTable);
          await db.execute(DBTables.createLevelsTable);
          await db.execute(DBTables.createScenesTable);
          await db.execute(DBTables.createScenesProgressTable);
          // insert ulang konten permainan
          await DBDummy.insertDummyAssetScene(db);
          for (final query in DBTables.dummyGameContentQueries) {
            await db.execute(query);
          }
        }
      },
    );
  }
}
