import 'package:equatable/equatable.dart';
import '../../models/budget_model.dart';

abstract class BudgetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Load budgets
class LoadBudgets extends BudgetEvent {}

// Add a budget
class AddBudget extends BudgetEvent {
  final Budget budget;
  AddBudget(this.budget);

  @override
  List<Object> get props => [budget];
}

// Update spent amount
class UpdateSpent extends BudgetEvent {
  final int budgetId;
  final double newSpent;
  UpdateSpent(this.budgetId, this.newSpent);

  @override
  List<Object> get props => [budgetId, newSpent];
}

// Delete budget
class DeleteBudget extends BudgetEvent {
  final int budgetId;
  DeleteBudget(this.budgetId);

  @override
  List<Object> get props => [budgetId];
}
