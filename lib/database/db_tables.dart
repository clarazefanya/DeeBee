import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DBTables {
  // Tabel users
  static const String createUsersTable = '''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      avatar_index INTEGER NOT NULL,
      role TEXT NOT NULL DEFAULT 'user',
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at TEXT NOT NULL,
      last_level_id INTEGER NULL,
      last_scene_id INTEGER NULL,
      xp INTEGER NOT NULL DEFAULT 0
    );
  ''';

  // Tabel asset_scene
  static const String createAssetSceneTable = '''
  CREATE TABLE asset_scene(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image_name TEXT NOT NULL,
    image BLOB NOT NULL,
    category TEXT NOT NULL
  );
  ''';

  //Tabel modules
  static const String createModulesTable = '''
  CREATE TABLE modules(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    module_name TEXT NOT NULL,
    description TEXT NOT NULL,
    is_published INTEGER NOT NULL DEFAULT 0
  );
  ''';

  //Tabel chapters
  static const String createChaptersTable = '''
  CREATE TABLE chapters(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    chapter_title TEXT NOT NULL,
    short_desc TEXT NOT NULL,
    long_desc TEXT NOT NULL,
    module_id INTEGER NOT NULL,
    FOREIGN KEY(module_id) REFERENCES modules(id) ON DELETE CASCADE
  );
  ''';

  //Tabel levels
  static const String createLevelsTable = '''
  CREATE TABLE levels(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    level_type TEXT NOT NULL,
    note TEXT,
    chapter_id INTEGER NOT NULL,
    FOREIGN KEY(chapter_id) REFERENCES chapters(id) ON DELETE CASCADE
  );
  ''';

  //Tabel scenes
  static const String createScenesTable = '''
  CREATE TABLE scenes(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    level_id INTEGER NOT NULL,
    bg_image_id INTEGER NOT NULL,
    char_image_id INTEGER NULL,
    char_name TEXT NOT NULL,
    char_dialog TEXT NOT NULL,
    scene_type TEXT NOT NULL,
    optional_sentence TEXT NULL,
    question TEXT NULL,
    option_a TEXT NULL,
    option_b TEXT NULL,
    option_c TEXT NULL,
    answer_key_multiple_choice TEXT NULL,
    answer_key TEXT NULL,
    reward_xp INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(level_id) REFERENCES levels(id) ON DELETE CASCADE,
    FOREIGN KEY(bg_image_id) REFERENCES asset_scene(id) ON DELETE RESTRICT,
    FOREIGN KEY(char_image_id) REFERENCES asset_scene(id) ON DELETE RESTRICT 
  );
  ''';

  //Tabel scene progress
  static const String createScenesProgressTable = '''
  CREATE TABLE user_scene_progress(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    scene_id INTEGER NOT NULL,
    is_completed INTEGER NOT NULL DEFAULT 0,
    earned_xp INTEGER NOT NULL DEFAULT 0,
    completed_at TEXT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(scene_id) REFERENCES scenes(id),
    UNIQUE(user_id, scene_id)
  );
  ''';

  // TODO: Tambah query CREATE TABLE lainnya di sini nanti

  // Query untuk insert data users admin & contoh/demo
  static const List<String> dummyUserQueries = [
    // Data Admin
    '''
    INSERT INTO users (name, email, password, avatar_index, role, is_active, created_at, last_level_id, xp)
    VALUES ('Super Admin', 'admin@mail.com', 'admin123', 1, 'admin', 1, '2026-01-01 08:00:00', NULL, 0);
    ''',

    // Data User 1 (Sudah main sampai level 5)
    '''
    INSERT INTO users (name, email, password, avatar_index, role, is_active, created_at, last_level_id, xp)
    VALUES ('Budi Setiawan', 'budi@gmail.com', '12345678', 2, 'user', 1, '2026-05-15 10:30:00', 5, 20);
    ''',

    // Data User 2 (User yang di-banned admin)
    '''
    INSERT INTO users (name, email, password, avatar_index, role, is_active, created_at, last_level_id, xp)
    VALUES ('Tukang Cheat', 'cheater@gmail.com', 'cheat123', 2, 'user', 0, '2026-06-01 14:20:00', 99, 1250);
    ''',

    // Data User 3 (fresh XP masih 0)
    '''
    INSERT INTO users (name, email, password, avatar_index, role, is_active, created_at, last_level_id, xp)
    VALUES ('Ani Mahalini', 'ani@gmail.com', '12345678', 0, 'user', 1, '2026-06-13 10:30:00', NULL, 0);
    ''',
  ];

  // Query untuk insert data contoh/demo
  static const List<String> dummyGameContentQueries = [
    // Data modul
    '''
    INSERT INTO modules (module_name, description, is_published)
    VALUES ('DML (Data Manipulation Languange)', 'Pelajari cara mengelola data dengan SELECT, INSERT, UPDATE.', 1);
    ''',

    // Data chapter
    '''
    INSERT INTO chapters (chapter_title, short_desc, long_desc, module_id)
    VALUES ('SELECT: Menampilkan Data', 'Belajar mengambil data dari tabel','Belajar mengambil data dari tabel menggunakan perintah SELECT dan memahami struktur query dasar SELECT.', 1);
    ''',

    // Data level - intro
    '''
    INSERT INTO levels (level_type, note, chapter_id)
    VALUES ('intro', 'Perkenalan karakter', 1);
    ''',

    // Data level - level 1
    '''
    INSERT INTO levels (level_type, note, chapter_id)
    VALUES ('gameplay', 'SELECT dasar', 1);
    ''',

    // Data level - level 2
    '''
    INSERT INTO levels (level_type, note, chapter_id)
    VALUES ('gameplay', 'WHERE dasar', 1);
    ''',

    // Intro (Level ID = 1)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type
    )
    VALUES (
      1,
      1,
      3,
      '???',
      '.....',
      'Dialog'
    );
    ''',

    // Intro (Level ID = 2)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type,
      optional_sentence
    )
    VALUES (
      1,
      1,
      5,
      'Adi',
      'Halo, Aku Adi, salah satu pemilik toko ini. Selamat datang di DeeBee, karyawan baru.',
      'Dialog',
      '(Senyumnya maksa banget...)'
    );
    ''',

    // Intro (Level ID = 3)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type
    )
    VALUES (
      1,
      1,
      4,
      'Adi',
      'Hari ini kamu akan dibimbing sama pemilik toko ini yang satu lagi, Bian.',
      'Dialog'
    );
    ''',

    // Intro (Level ID = 4)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type,
      optional_sentence
    )
    VALUES (
      1,
      2,
      7,
      'Adi',
      '....semoga kalian berdua cocok.',
      'Dialog',
      '(.....)'
    );
    ''',

    // Level 1 - Scene 1 (Dialog)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type,
      optional_sentence
    )
    VALUES (
      2,
      2,
      10,
      'Bian',
      'Halo!!!!',
      'Dialog',
      '....hai?'
    );
    ''',

    // Level 1 - Scene 2 (Multiple Choice)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type,
      question,
      option_a,
      option_b,
      option_c,
      answer_key_multiple_choice,
      reward_xp
    )
    VALUES (
      2,
      2,
      10,
      'Bian',
      'Pertama-tama, aku mau lihat kemampuanmu, mungkin dimulai dari lihat data produk dulu.',
      'Pilihan ganda',
      'Perintah SQL untuk menampilkan data dari tabel adalah...',
      'SELECT',
      'SHOW',
      'DISPLAY',
      'A',
      10
    );
    ''',

    // Level 1 - Scene 3 (Susun kata)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type,
      question,
      answer_key,
      reward_xp
    )
    VALUES (
      2,
      2,
      10,
      'Bian',
      'Bagaimana cara melihat semua data produk?',
      'Susun kata',
      'Susun kata di bawah ini menjadi query yang benar.',
      'SELECT * FROM products',
      10
    );
    ''',

    // Level 1 - Scene 4 (SQL Input)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type,
      question,
      answer_key,
      reward_xp
    )
    VALUES (
      2,
      2,
      8,
      'Bian',
      'Pada SELECT, * digunakan untuk menampilkan semua kolom. Kamu bisa menampilkan kolom spesifik dengan mengganti * dengan nama kolom yang ingin ditampilkan.\nSekarang tuliskan query untuk hanya melihat nama produknya saja.',
      'Tulis SQL',
      'Tampilkan data hanya pada kolom "name" dari tabel products.',
      'SELECT name FROM products',
      20
    );
    ''',

    // Level 2 - Scene 1 (Testing Area)
    '''
    INSERT INTO scenes (
      level_id,
      bg_image_id,
      char_image_id,
      char_name,
      char_dialog,
      scene_type
    )
    VALUES (
    3,
    1,
    9,
    'Bian',
    'Level ini digunakan untuk eksperimen create, edit, dan delete scene Admin.\nAccess: admin@mail.com, admin123',
    'Dialog'
    );
    ''',
  ];
}

// DUMMY DATA ASSET SCENE
class DBDummy {
  static Future<void> insertDummyAssetScene(Database db) async {
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
