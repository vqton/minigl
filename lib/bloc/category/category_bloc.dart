import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:minigl/database/app_database.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../models/category_model.dart' as AppModels;

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
  }

  Future<void> _onEditCategory(
    EditCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i(
      "Updating category: ID=${event.category.id} Name=${event.category.name} Type=${event.category.type}",
    );

    try {
      final updatedCategory = CategoriesCompanion(
        id: Value(event.category.id),
        name: Value(event.category.name),
        type: Value(event.category.type), // ✅ Ensure type is updated
        icon:
            event.category.icon != null
                ? Value(event.category.icon!)
                : const Value.absent(),
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
    logger.i("Loading categories...");
    try {
      final dbCategories = await database.getAllCategories();

      // Convert DB categories to AppModels.Category
      final categories =
          dbCategories
              .map(
                (dbCategory) => AppModels.Category(
                  id: dbCategory.id,
                  name: dbCategory.name,
                  type: dbCategory.type, // ✅ FIX: Use the actual type
                  icon: dbCategory.icon, // ✅ Use actual icon (nullable)
                ),
              )
              .toList();
      logger.i("Loaded ${categories.length} categories");
      emit(CategoryLoaded(categories));
    } catch (e) {
      logger.e("Error loading categories: $e");
      emit(CategoryError("Failed to load categories"));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i(
      "Adding category: ${event.category.name} (${event.category.type})",
    );
    try {
      await database.insertCategory(
        CategoriesCompanion(
          name: Value(event.category.name), // ✅ FIXED: Wrap in `Value<>`
          type: Value(event.category.type),
          icon:
              event.category.icon != null
                  ? Value(event.category.icon!)
                  : const Value.absent(),
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
        "Updating category: ID=${event.category.id} Type=${event.category.type}",
      );

      final updatedCategory = CategoriesCompanion(
        id: Value(event.category.id),
        name: Value(event.category.name),
        type: Value(event.category.type),
        icon:
            event.category.icon != null
                ? Value(event.category.icon!)
                : const Value.absent(),
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
}
