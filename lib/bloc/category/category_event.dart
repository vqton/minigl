import 'package:equatable/equatable.dart';
import 'package:minigl/models/category_model.dart';


abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Load Categories
class LoadCategories extends CategoryEvent {}

// Add a new category
class AddCategory extends CategoryEvent {
  final Category category;
  AddCategory(this.category);

  @override
  List<Object> get props => [category];
}

// Delete a category
class DeleteCategory extends CategoryEvent {
  final int categoryId;
  DeleteCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
class UpdateCategory extends CategoryEvent {
  final Category category;

  UpdateCategory(this.category);

  @override
  List<Object> get props => [category];
}
class EditCategory extends CategoryEvent {
  final Category category;

  EditCategory(this.category);

  @override
  List<Object> get props => [category];
}

// ✅ New event to clear all categories
class ClearCategories extends CategoryEvent {}