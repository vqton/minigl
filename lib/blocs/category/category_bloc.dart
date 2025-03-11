// lib/blocs/category/category_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:minigl/models/category.dart';
import 'package:minigl/services/category_service.dart';
import 'package:minigl/utils/logger.dart';
// import '../utils/logger.dart';
// import '../services/category_service.dart';
// import '../models/category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService _service = CategoryService();
  List<Category> _categories = [];

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      _categories = await _service.getCategories();
      emit(CategoryLoadSuccess(_categories));
      AppLogger.info('Loaded ${_categories.length} categories');
    } catch (e) {
      emit(CategoryError('Failed to load categories'));
      AppLogger.error('Category load error', e);
    }
  }

  Future<void> _onAddCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      await _service.addCategory(event.category);
      emit(CategoryOperationSuccess('Category added successfully'));
      add(LoadCategories()); // Refresh list
    } catch (e) {
      emit(CategoryError(e.toString()));
      AppLogger.error('Add category error', e);
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategory event, Emitter<CategoryState> emit) async {
    try {
      await _service.updateCategory(event.category);
      emit(CategoryOperationSuccess('Category updated successfully'));
      add(LoadCategories()); // Refresh list
    } catch (e) {
      emit(CategoryError(e.toString()));
      AppLogger.error('Update category error', e);
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      await _service.deleteCategory(event.categoryId);
      emit(CategoryOperationSuccess('Category deleted successfully'));
      add(LoadCategories()); // Refresh list
    } catch (e) {
      emit(CategoryError(e.toString()));
      AppLogger.error('Delete category error', e);
    }
  }

  void _onSelectCategory(
      SelectCategory event, Emitter<CategoryState> emit) {
    if (state is CategoryLoadSuccess) {
      final currentState = state as CategoryLoadSuccess;
      emit(CategoryLoadSuccess(
        currentState.categories,
        selectedCategory: event.category,
      ));
    }
  }

  @override
  void onChange(Change<CategoryState> change) {
    super.onChange(change);
    AppLogger.debug('CategoryBloc state changed: ${change.nextState}');
  }
}