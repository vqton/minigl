import 'package:equatable/equatable.dart';
import 'package:minigl/models/category_model.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

// 🟡 Initial State (Before categories are fetched)
class CategoryInitial extends CategoryState {}

// 🔄 Loading State
class CategoryLoading extends CategoryState {}  

// ✅ Loaded State (After fetching categories from ObjectBox)
class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

// ❌ Error State (If fetching fails)
class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

// 🚫 Empty State (When no categories exist)
class CategoryEmpty extends CategoryState {}
