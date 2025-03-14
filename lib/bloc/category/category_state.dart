import 'package:equatable/equatable.dart';
import 'package:minigl/models/category_model.dart';


abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial State
class CategoryInitial extends CategoryState {}

// Categories Loaded
class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

// Error State
class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}
