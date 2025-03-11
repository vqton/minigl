// lib/blocs/category/category_event.dart
import 'package:minigl/models/category.dart';

abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Category category;
  AddCategory(this.category);
}

class UpdateCategory extends CategoryEvent {
  final Category category;
  UpdateCategory(this.category);
}

class DeleteCategory extends CategoryEvent {
  final int categoryId;
  DeleteCategory(this.categoryId);
}

class SelectCategory extends CategoryEvent {
  final Category category;
  SelectCategory(this.category);
}