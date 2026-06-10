class DBTables {
  // Query untuk membuat tabel users
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
      last_level_id INTEGER NULL
      xp INTEGER NOT NULL DEFAULT 0
    );
  ''';

  // TODO: Tambah query CREATE TABLE lainnya di sini nanti
  // static const String createProgressTable = ''' ... ''';

  // Query untuk insert data contoh/demo
  static const List<String> dummyDataQueries = [
    // Data Admin
    '''
    INSERT INTO users (name, email, password, avatar_index, role, is_active, created_at, last_level_id)
    VALUES ('Super Admin', 'admin@deebee.com', 'admin123', 1, 'admin', 1, '2026-01-01 08:00:00', NULL, 0);
    ''',

    // Data User 1 (Sudah main sampai level 5)
    '''
    INSERT INTO users (name, email, password, avatar_index, role, is_active, created_at, last_level_id)
    VALUES ('Budi Setiawan', 'budi@gmail.com', 'budi123', 2, 'user', 1, '2026-05-15 10:30:00', 5, 50);
    ''',

    // Data User 2 (User yang di-banned admin)
    '''
    INSERT INTO users (name, email, password, avatar_index, role, is_active, created_at, last_level_id)
    VALUES ('Tukang Cheat', 'cheater@gmail.com', 'cheat123', 3, 'user', 0, '2026-06-01 14:20:00', 99, 1250);
    ''',
  ];
}
