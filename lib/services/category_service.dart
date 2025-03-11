// lib/services/category_service.dart
import 'package:minigl/models/transaction.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/database_helper.dart';
import '../models/category.dart';

class CategoryService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Category>> getCategories({TransactionType? type}) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> maps;
    
    if (type != null) {
      maps = await db.query(
        'categories',
        where: 'type = ?',
        whereArgs: [type.name],
      );
    } else {
      maps = await db.query('categories');
    }
    
    return List.generate(maps.length, (i) => Category.fromJson(maps[i]));
  }

  Future<Category> getCategoryById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) {
      throw Exception('Category not found');
    }
    
    return Category.fromJson(maps.first);
  }

  Future<Category> addCategory(Category category) async {
    final db = await _dbHelper.database;
    try {
      final id = await db.insert(
        'categories',
        category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
      
      // Return category with generated ID
      return category.copyWith(id: id);
    } catch (e) {
      throw Exception('Failed to add category: ${e.toString()}');
    }
  }

  Future<void> updateCategory(Category category) async {
    final db = await _dbHelper.database;
    
    if (category.id == null) {
      throw Exception('Category ID is required for update');
    }
    
    final result = await db.update(
      'categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    
    if (result == 0) {
      throw Exception('Category not found');
    }
  }

  Future<void> deleteCategory(int id) async {
    final db = await _dbHelper.database;
    
    // Handle related transactions first
    await db.rawUpdate('''
      UPDATE transactions 
      SET category_id = NULL 
      WHERE category_id = ?
    ''', [id]);
    
    final result = await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result == 0) {
      throw Exception('Category not found');
    }
  }

  Future<void> ensureDefaultCategories() async {
    final db = await _dbHelper.database;
    final defaultCategories = [
      Category(
        name: 'Salary',
        type: TransactionType.income,
        color: '#4CAF50',
      ),
      Category(
        name: 'Groceries',
        type: TransactionType.expense,
        color: '#FF9800',
      ),
      // Add more default categories
    ];
    
    for (var category in defaultCategories) {
      final exists = await db.query(
        'categories',
        where: 'name = ?',
        whereArgs: [category.name],
      );
      
      if (exists.isEmpty) {
        await addCategory(category);
      }
    }
  }
}