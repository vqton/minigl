import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../models/category_model.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Store store;
  final Logger logger = Logger(); // Logger for debugging

  CategoryBloc(this.store) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<EditCategory>(_onEditCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<ClearCategories>(_onClearCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i("🔄 Loading categories from ObjectBox...");

    try {
      final box = store.box<Category>();
      final categories = box.getAll();
      logger.i("📂 Loaded ${categories.length} categories.");
      emit(CategoryLoaded(categories));
    } catch (e, stackTrace) {
      logger.e("⛔ Error loading categories: $e", error: e, stackTrace: stackTrace);
      emit(CategoryError("Failed to load categories"));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i("Adding category: ${event.category.name} (${event.category.type})");

    try {
      final box = store.box<Category>();
      box.put(event.category);
      logger.i("✅ Category added successfully with ID: ${event.category.id}");
      add(LoadCategories()); // Refresh categories
    } catch (e) {
      logger.e("⛔ Failed to add category: $e");
      emit(CategoryError("Failed to add category"));
    }
  }

  Future<void> _onEditCategory(
    EditCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i("Editing category: ID=${event.category.id}");

    try {
      final box = store.box<Category>();
      final category = box.get(event.category.id);

      if (category != null) {
        category.name = event.category.name;
        category.type = event.category.type;
        category.icon = event.category.icon;
        category.color = event.category.color;
        box.put(category);
        logger.i("✅ Category updated successfully.");
        add(LoadCategories());
      } else {
        logger.w("⚠️ Category not found for update.");
      }
    } catch (e) {
      logger.e("⛔ Failed to edit category: $e");
      emit(CategoryError("Failed to edit category"));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.i("Updating category: ID=${event.category.id}");

    try {
      final box = store.box<Category>();
      final category = box.get(event.category.id);

      if (category != null) {
        category.name = event.category.name;
        category.type = event.category.type;
        category.icon = event.category.icon;
        category.color = event.category.color;
        box.put(category);
        logger.i("✅ Category updated successfully.");
        add(LoadCategories());
      } else {
        logger.w("⚠️ Category not found for update.");
      }
    } catch (e) {
      logger.e("⛔ Failed to update category: $e");
      emit(CategoryError("Failed to update category"));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    logger.w("Deleting category ID=${event.categoryId}");

    try {
      final box = store.box<Category>();
      box.remove(event.categoryId);
      logger.i("✅ Category deleted successfully.");
      add(LoadCategories());
    } catch (e) {
      logger.e("⛔ Failed to delete category: $e");
      emit(CategoryError("Failed to delete category"));
    }
  }

  Future<void> _onClearCategories(
    ClearCategories event,
    Emitter<CategoryState> emit,
  ) async {
    logger.w("⚠️ Clearing all categories...");

    try {
      final box = store.box<Category>();
      box.removeAll();
      logger.i("✅ All categories cleared.");
      emit(CategoryLoaded([])); // Emit empty state
    } catch (e) {
      logger.e("⛔ Failed to clear categories: $e");
      emit(CategoryError("Failed to clear categories"));
    }
  }
}
