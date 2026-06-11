import 'package:deebee_user/database/db_tables.dart';
import 'package:deebee_user/database/exercise_db_tables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseDbHelper {
  // db helper singleton
  static final ExerciseDbHelper _instance = ExerciseDbHelper._internal();
  factory ExerciseDbHelper() => _instance;
  ExerciseDbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // function panggil/init db
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'exercise.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 1. Eksekusi pembuatan tabel
        await db.execute(ExerciseDbTables.createCustomersTable);
        await db.execute(ExerciseDbTables.createProductsTable);
        await db.execute(ExerciseDbTables.createTransactionsTable);

        // 2. Eksekusi insert data
        for (String query in DBTables.dummyDataQueries) {
          await db.execute(query);
        }
      },
    );
  }
}
