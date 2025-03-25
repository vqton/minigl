import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:objectbox/objectbox.dart';
import 'package:minigl/bloc/budget/budget_event.dart';
import 'package:minigl/bloc/budget/budget_state.dart';
import 'package:minigl/models/budget_model.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final Store store; // ✅ Corrected: Store instead of database
  final Logger _logger = Logger();

  BudgetBloc(this.store) : super(BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<AddBudget>(_onAddBudget);
    on<UpdateSpent>(_onUpdateSpent);
    on<DeleteBudget>(_onDeleteBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      _logger.i("Loading budgets from ObjectBox database...");
      final box = store.box<Budget>(); // ✅ Updated reference
      final budgets = box.getAll();
      emit(BudgetLoaded(budgets));
      _logger.i("Budgets loaded successfully: ${budgets.length} found.");
    } catch (e, stacktrace) {
      _logger.e("Failed to load budgets", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to load budgets."));
    }
  }

  Future<void> _onAddBudget(AddBudget event, Emitter<BudgetState> emit) async {
    try {
      _logger.i("Adding new budget: ${event.budget.name}");
      final box = store.box<Budget>(); // ✅ Updated reference
      final newBudget = event.budget;
      box.put(newBudget);
      _logger.i("Budget added with ID: ${newBudget.id}");
      add(LoadBudgets());
    } catch (e, stacktrace) {
      _logger.e("Failed to add budget", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to add budget."));
    }
  }

  Future<void> _onUpdateSpent(
    UpdateSpent event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      _logger.i("Updating spent amount for budget ID: ${event.budgetId}");
      final box = store.box<Budget>(); // ✅ Updated reference
      final budget = box.get(event.budgetId);
      if (budget != null) {
        budget.spent = event.newSpent;
        box.put(budget);
        _logger.i("Spent amount updated successfully.");
        add(LoadBudgets());
      } else {
        _logger.w("Budget not found for update.");
      }
    } catch (e, stacktrace) {
      _logger.e("Failed to update budget", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to update budget."));
    }
  }

  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      _logger.w("Deleting budget ID: ${event.budgetId}");
      final box = store.box<Budget>(); // ✅ Updated reference
      box.remove(event.budgetId);
      _logger.w("Budget deleted successfully.");
      add(LoadBudgets());
    } catch (e, stacktrace) {
      _logger.e("Failed to delete budget", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to delete budget."));
    }
  }
}
