import 'package:equatable/equatable.dart';
import '../../models/budget_model.dart';

abstract class BudgetState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state
class BudgetInitial extends BudgetState {}

// Budgets Loaded
class BudgetLoaded extends BudgetState {
  final List<Budget> budgets;
  BudgetLoaded(this.budgets);

  @override
  List<Object> get props => [budgets];
}

// Error State
class BudgetError extends BudgetState {
  final String message;
  BudgetError(this.message);

  @override
  List<Object> get props => [message];
}
