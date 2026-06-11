import 'package:deebee_user/database/db_tables.dart';
import 'package:flutter/services.dart';
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
        await db.execute(DBTables.createAssetSceneTable);
        await db.execute(DBTables.createModulesTable);
        await db.execute(DBTables.createChaptersTable);
        await db.execute(DBTables.createLevelsTable);
        await db.execute(DBTables.createScenesTable);

        // 2. Eksekusi insert data demo/dummy
        for (String query in DBTables.dummyDataQueries) {
          await db.execute(query);
        }

        // 3. Data dummy assetscene
        await _insertDummyAssetScene(db);
      },
    );
  }

  // DUMMY DATA ASSET SCENE
  Future<void> _insertDummyAssetScene(Database db) async {
    final bg1 = await rootBundle.load(
      'assets/images/demo/Background-kasir.jpg',
    );
    final bg2 = await rootBundle.load(
      'assets/images/demo/Background-lorong.jpg',
    );
    final charAdi1 = await rootBundle.load('assets/images/demo/Adi-idle.png');
    final charAdi2 = await rootBundle.load('assets/images/demo/Adi-intro.png');
    final charAdi3 = await rootBundle.load('assets/images/demo/Adi-smile.png');
    final charAdi4 = await rootBundle.load('assets/images/demo/Adi-speak.png');
    final charBian1 = await rootBundle.load(
      'assets/images/demo/Bian-intro.png',
    );
    final charBian2 = await rootBundle.load(
      'assets/images/demo/Bian-smile.png',
    );
    final charBian3 = await rootBundle.load(
      'assets/images/demo/Bian-smile-2.png',
    );
    final charBian4 = await rootBundle.load(
      'assets/images/demo/Bian-speak.png',
    );

    await db.insert('asset_scene', {
      'image_name': 'Background-kasir.jpg',
      'image': bg1.buffer.asUint8List(),
      'category': 'Background',
    });

    await db.insert('asset_scene', {
      'image_name': 'Background-lorong.jpg',
      'image': bg2.buffer.asUint8List(),
      'category': 'Background',
    });

    await db.insert('asset_scene', {
      'image_name': 'Adi-idle.png',
      'image': charAdi1.buffer.asUint8List(),
      'category': 'Karakter',
    });

    await db.insert('asset_scene', {
      'image_name': 'Adi-intro.png',
      'image': charAdi2.buffer.asUint8List(),
      'category': 'Karakter',
    });

    await db.insert('asset_scene', {
      'image_name': 'Adi-smile.png',
      'image': charAdi3.buffer.asUint8List(),
      'category': 'Karakter',
    });

    await db.insert('asset_scene', {
      'image_name': 'Adi-speak.png',
      'image': charAdi4.buffer.asUint8List(),
      'category': 'Karakter',
    });

    await db.insert('asset_scene', {
      'image_name': 'Bian-intro.png',
      'image': charBian1.buffer.asUint8List(),
      'category': 'Karakter',
    });

    await db.insert('asset_scene', {
      'image_name': 'Bian-smile.png',
      'image': charBian2.buffer.asUint8List(),
      'category': 'Karakter',
    });

    await db.insert('asset_scene', {
      'image_name': 'Bian-smile-2.png',
      'image': charBian3.buffer.asUint8List(),
      'category': 'Karakter',
    });

    await db.insert('asset_scene', {
      'image_name': 'Bian-speak.png',
      'image': charBian4.buffer.asUint8List(),
      'category': 'Karakter',
    });
  }
}
