import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'chipernote.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // App Settings Table
    await db.execute('''
      CREATE TABLE app_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // User Authentication Table
    await db.execute('''
      CREATE TABLE user_auth (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        master_password_hash TEXT NOT NULL,
        salt TEXT NOT NULL,
        biometric_enabled INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Notes Table (encrypted)
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        encrypted_data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_pinned INTEGER NOT NULL DEFAULT 0,
        color TEXT
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_notes_created_at ON notes(created_at DESC)');
    await db.execute('CREATE INDEX idx_notes_pinned ON notes(is_pinned, created_at DESC)');
  }

  // App Settings Methods
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    await db.insert(
      'app_settings',
      {
        'key': key,
        'value': value,
        'created_at': now,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (result.isNotEmpty) {
      return result.first['value'] as String;
    }
    return null;
  }

  Future<bool> hasCompletedOnboarding() async {
    final value = await getSetting('onboarding_completed');
    return value == 'true';
  }

  Future<void> setOnboardingCompleted() async {
    await setSetting('onboarding_completed', 'true');
  }

  // User Authentication Methods
  Future<void> saveMasterPassword({
    required String passwordHash,
    required String salt,
    required bool biometricEnabled,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Delete any existing auth record
    await db.delete('user_auth');

    await db.insert('user_auth', {
      'master_password_hash': passwordHash,
      'salt': salt,
      'biometric_enabled': biometricEnabled ? 1 : 0,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<Map<String, dynamic>?> getMasterPasswordData() async {
    final db = await database;
    final result = await db.query('user_auth', limit: 1);
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<bool> hasMasterPassword() async {
    final data = await getMasterPasswordData();
    return data != null;
  }

  Future<void> updateBiometricEnabled(bool enabled) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      'user_auth',
      {
        'biometric_enabled': enabled ? 1 : 0,
        'updated_at': now,
      },
    );
  }

  // Notes Methods
  Future<void> saveNote({
    required String id,
    required String title,
    required String content,
    required String encryptedData,
    String? color,
    bool ispinned = false,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert(
      'notes',
      {
        'id': id,
        'title': title,
        'content': content,
        'encrypted_data': encryptedData,
        'created_at': now,
        'updated_at': now,
        'is_pinned': ispinned ? 1 : 0,
        'color': color,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query(
      'notes',
      orderBy: 'created_at DESC',
    );
  }

  Future<Map<String, dynamic>?> getNoteById(String id) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> togglepinned(String id, bool ispinned) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      'notes',
      {
        'is_pinned': ispinned ? 1 : 0,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
