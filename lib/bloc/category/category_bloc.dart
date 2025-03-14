import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/database/app_database.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../models/category_model.dart' as AppModels;

import 'package:drift/drift.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AppDatabase database;

  CategoryBloc(this.database) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<EditCategory>(_onEditCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onEditCategory(
    EditCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final updatedCategory = CategoriesCompanion(
        id: Value(event.category.id),
        name: Value(event.category.name),
      );

      await database.updateCategory(updatedCategory);
      add(LoadCategories()); // Refresh categories after update
    } catch (e) {
      emit(CategoryError("Failed to update category"));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final dbCategories = await database.getAllCategories();

      // Convert DB categories to AppModels.Category
      final categories =
          dbCategories
              .map(
                (dbCategory) => AppModels.Category(
                  id: dbCategory.id,
                  name: dbCategory.name,
                  type: "expense", // Default until properly set
                  icon: "", // Placeholder until icon handling is implemented
                ),
              )
              .toList();

      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError("Failed to load categories"));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await database.insertCategory(
        CategoriesCompanion(
          name: Value(event.category.name), // ✅ FIXED: Wrap in `Value<>`
        ),
      );
      add(LoadCategories()); // Refresh categories
    } catch (e) {
      emit(CategoryError("Failed to add category"));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await database.deleteCategory(event.categoryId);
      add(LoadCategories()); // Refresh categories
    } catch (e) {
      emit(CategoryError("Failed to delete category"));
    }
  }
}
