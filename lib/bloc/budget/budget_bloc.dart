import 'package:flutter_bloc/flutter_bloc.dart';
import 'budget_event.dart';
import 'budget_state.dart';
import '../../models/budget_model.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<AddBudget>(_onAddBudget);
    on<UpdateSpent>(_onUpdateSpent);
    on<DeleteBudget>(_onDeleteBudget);
  }

  List<Budget> _budgets = [
    Budget(id: 1, category: "Food", amount: 500, spent: 200),
    Budget(id: 2, category: "Transport", amount: 300, spent: 150),
  ];

  void _onLoadBudgets(LoadBudgets event, Emitter<BudgetState> emit) {
    emit(BudgetLoaded(List.from(_budgets)));
  }

  void _onAddBudget(AddBudget event, Emitter<BudgetState> emit) {
    _budgets.add(event.budget);
    emit(BudgetLoaded(List.from(_budgets)));
  }

  void _onUpdateSpent(UpdateSpent event, Emitter<BudgetState> emit) {
    _budgets = _budgets.map((budget) {
      return budget.id == event.budgetId ? budget.copyWith(spent: event.newSpent) : budget;
    }).toList();
    emit(BudgetLoaded(List.from(_budgets)));
  }

  void _onDeleteBudget(DeleteBudget event, Emitter<BudgetState> emit) {
    _budgets.removeWhere((budget) => budget.id == event.budgetId);
    emit(BudgetLoaded(List.from(_budgets)));
  }
}
