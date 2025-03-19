import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:minigl/database/app_database.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../models/category_model.dart' as app_models;

import 'package:drift/drift.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AppDatabase database;
  final Logger logger = Logger(); // ✅ Initialize Logger

  CategoryBloc(this.database) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<EditCategory>(_onEditCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<ClearCategories>(_onClearCategories);
  }

  Future<void> _onEditCategory(
    EditCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i(
      "Updating category: ID=${event.category.id} Name=${event.category.name} Type=${event.category.type} Color=${event.category.color}",
    );

    try {
      final updatedCategory = CategoriesCompanion(
        id: Value(event.category.id),
        name: Value(event.category.name),
        type: Value(event.category.type),
        icon:
            event.category.icon != null
                ? Value(event.category.icon!)
                : const Value.absent(),
        color: Value(event.category.color),
      );

      int rowsAffected = await database.updateCategory(updatedCategory);

      if (rowsAffected > 0) {
        logger.i("Category updated successfully");
      } else {
        logger.w("No rows were updated. Check if the ID exists.");
      }

      add(LoadCategories()); // ✅ Refresh categories
    } catch (e) {
      logger.e("Failed to update category: $e");
      emit(CategoryError("Failed to update category"));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i("🔄 Loading categories...");

    try {
      final dbCategories = await database.getAllCategories();
      logger.i("📂 Fetched ${dbCategories.length} categories from database.");

      final categories =
          dbCategories.map((dbCategory) {
            return app_models.Category(
              id: dbCategory.id,
              name: dbCategory.name,
              type: dbCategory.type,
              icon: dbCategory.icon,
              color: dbCategory.color, // Default to white if null
            );
          }).toList();

      logger.i("✅ Successfully loaded ${categories.length} categories.");
      emit(CategoryLoaded(categories));
    } catch (e, stackTrace) {
      logger.e(
        "⛔ Error loading categories: $e",
        error: e,
        stackTrace: stackTrace,
      );
      emit(CategoryError("Failed to load categories"));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i(
      "Adding category: ${event.category.name} (${event.category.type}) Color=${event.category.color}",
    );
    try {
      await database.insertCategory(
        CategoriesCompanion(
          name: Value(event.category.name),
          type: Value(event.category.type),
          icon:
              event.category.icon != null
                  ? Value(event.category.icon!)
                  : const Value.absent(),
          color: Value(event.category.color),
        ),
      );
      logger.i("Category added successfully");
      add(LoadCategories()); // Refresh categories
    } catch (e) {
      logger.e("Failed to add category: $e");
      emit(CategoryError("Failed to add category"));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.w("Deleting category ID=${event.categoryId}");
    try {
      await database.deleteCategory(event.categoryId);
      logger.i("Category deleted successfully");
      add(LoadCategories()); // Refresh categories
    } catch (e) {
      logger.e("Failed to delete category: $e");
      emit(CategoryError("Failed to delete category"));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      logger.i(
        "Updating category: ID=${event.category.id} Type=${event.category.type} Color=${event.category.color}",
      );

      final updatedCategory = CategoriesCompanion(
        id: Value(event.category.id),
        name: Value(event.category.name),
        type: Value(event.category.type),
        icon:
            event.category.icon != null
                ? Value(event.category.icon!)
                : const Value.absent(),
        color: Value(event.category.color),
      );

      int rowsAffected = await database.updateCategory(updatedCategory);

      if (rowsAffected > 0) {
        logger.i("Category updated successfully");
      } else {
        logger.w("No rows were updated. Check if the ID exists.");
      }

      add(LoadCategories()); // ✅ Refresh categories
    } catch (e) {
      logger.e("Failed to update category: $e");
      emit(CategoryError("Failed to update category"));
    }
  }

  Future<void> _onClearCategories(
    ClearCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      logger.w("Clearing all categories");
      await database.clearCategories();
      logger.i("All categories cleared");
      emit(CategoryLoaded([])); // Emit empty state
    } catch (e) {
      logger.e("Failed to clear categories: $e");
      emit(CategoryError("Failed to clear categories"));
    }
  }
}
