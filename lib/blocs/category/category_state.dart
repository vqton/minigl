// lib/blocs/category/category_state.dart
import 'package:minigl/models/category.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<Category> categories;
  final Category? selectedCategory;
  CategoryLoadSuccess(this.categories, {this.selectedCategory});
}

class CategoryOperationSuccess extends CategoryState {
  final String message;
  CategoryOperationSuccess(this.message);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}