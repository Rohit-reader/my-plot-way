import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/user.dart';
import '../../models/property.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('myplotway.db');
    return _db!;
  }

  Future<Database> _initDB(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, filename);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        role TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE properties (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        description TEXT,
        imagePath TEXT,
        address TEXT,
        city TEXT,
        pinCode TEXT,
        sellerId INTEGER
      )
    ''');
    // default admin
    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123',
      'role': 'admin',
    });
  }

  // --- user CRUD
  Future<int> insertUser(UserModel u) async {
    final db = await database;
    return await db.insert('users', u.toMap());
  }

  Future<UserModel?> loginUser(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username=? AND password=?',
      whereArgs: [username, password],
    );
    if (res.isEmpty) return null;
    return UserModel.fromMap(res.first);
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final res = await db.query('users');
    return res.map((m) => UserModel.fromMap(m)).toList();
  }

  // --- properties
  Future<int> insertProperty(Property p) async {
    final db = await database;
    return await db.insert('properties', p.toMap());
  }

  Future<List<PropertyModel>> getProperties() async {
    final db = await database;
    final res = await db.query('properties', orderBy: 'id DESC');
    return res.map((m) => Property.fromMap(m)).toList();
  }

  Future<int> updateProperty(Property p) async {
    final db = await database;
    return await db.update(
      'properties',
      p.toMap(),
      where: 'id=?',
      whereArgs: [p.id],
    );
  }

  Future<int> deleteProperty(int id) async {
    final db = await database;
    return await db.delete('properties', where: 'id=?', whereArgs: [id]);
  }
}
