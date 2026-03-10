import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;
  
  // For Web purely for demo screenshots
  List<Item> _webItems = [];

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            isFavorite INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertItem(Item item) async {
    if (kIsWeb) {
      final index = _webItems.indexWhere((e) => e.id == item.id);
      if (index >= 0) _webItems[index] = item;
      else _webItems.add(item);
      return;
    }
    final db = await database;
    await db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateItemFavorite(int id, bool isFavorite) async {
    if (kIsWeb) {
      final item = _webItems.firstWhere((e) => e.id == id);
      item.isFavorite = isFavorite;
      return;
    }
    final db = await database;
    await db.update(
      'items',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Item>> getItems() async {
    if (kIsWeb) {
      return List.from(_webItems);
    }
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<void> clearItems() async {
    if (kIsWeb) {
      _webItems.clear();
      return;
    }
    final db = await database;
    await db.delete('items');
  }

  // Preserve favorites when syncing
  Future<void> syncItems(List<Item> newItems) async {
    if (kIsWeb) {
       List<int> favoriteIds = _webItems.where((e) => e.isFavorite).map((e) => e.id).toList();
       _webItems.clear();
       for (var item in newItems) {
         if (favoriteIds.contains(item.id)) {
           item.isFavorite = true;
         }
         _webItems.add(item);
       }
       return;
    }
    final db = await database;
    
    // Get existing favorites to keep them
    final List<Map<String, dynamic>> existing = await db.query('items', where: 'isFavorite = 1');
    List<int> favoriteIds = existing.map((e) => e['id'] as int).toList();

    await db.transaction((txn) async {
      await txn.delete('items');
      for (var item in newItems) {
        if (favoriteIds.contains(item.id)) {
          item.isFavorite = true;
        }
        await txn.insert('items', item.toMap());
      }
    });
  }

  Future<int> getCount() async {
    if (kIsWeb) {
      return _webItems.length;
    }
    final db = await database;
    var x = await db.rawQuery('SELECT COUNT (*) from items');
    int count = Sqflite.firstIntValue(x) ?? 0;
    return count;
  }
}
