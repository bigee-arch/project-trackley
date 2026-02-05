import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      print('[DatabaseHelper] Initializing database...');
      _database = await _initDB('streakquest.db');
      print('[DatabaseHelper] Database initialized successfully');
      return _database!;
    } catch (e, stackTrace) {
      print('[DatabaseHelper] ERROR initializing database: $e');
      print('[DatabaseHelper] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    String path;

    if (kIsWeb) {
      // On web, just use the filename directly
      path = filePath;
      print('[DatabaseHelper] Running on WEB, using path: $path');
    } else {
      // On mobile/desktop, use the standard database path
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
      print('[DatabaseHelper] Running on NATIVE, using path: $path');
    }

    print('[DatabaseHelper] Opening database at: $path');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print(
        '[DatabaseHelper] Upgrading database from v$oldVersion to v$newVersion');
    if (oldVersion < 2) {
      // Add streak columns to habits table
      await db.execute(
          'ALTER TABLE habits ADD COLUMN current_streak INTEGER DEFAULT 0');
      await db.execute(
          'ALTER TABLE habits ADD COLUMN longest_streak INTEGER DEFAULT 0');
      await db
          .execute('ALTER TABLE habits ADD COLUMN last_completed_date TEXT');
      print('[DatabaseHelper] Added streak columns to habits table');
    }
  }

  Future _createDB(Database db, int version) async {
    print('[DatabaseHelper] Creating database tables...');
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE habits (
        id $idType,
        title $textType,
        description TEXT,
        color $intType,
        icon_code $intType,
        frequency_type $textType,
        frequency_days TEXT,
        target_per_day $intType,
        created_at $textType,
        is_archived $boolType,
        current_streak INTEGER DEFAULT 0,
        longest_streak INTEGER DEFAULT 0,
        last_completed_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE habit_logs (
        id $idType,
        habit_id $intType,
        date $textType,
        value $intType,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        amount $realType,
        title $textType,
        category $textType,
        is_income $boolType,
        date $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE user_stats (
        id $intType PRIMARY KEY,
        display_name $textType,
        xp $intType,
        level $intType,
        coins $intType,
        total_habits_completed $intType,
        current_streak $intType,
        longest_streak $intType,
        last_active_date $textType
      )
    ''');
    print('[DatabaseHelper] Created user_stats table');

    // Seed Initial User
    await db.insert(
        'user_stats',
        UserStats(
                id: 1,
                displayName: 'Adventurer',
                lastActiveDate: DateTime.now().toIso8601String().split('T')[0])
            .toMap());
    print('[DatabaseHelper] Seeded initial user data');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
