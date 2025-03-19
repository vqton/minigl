import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:minigl/bloc/budget/budget_event.dart';
import 'package:minigl/bloc/budget/budget_state.dart';
import 'package:minigl/database/app_database.dart' as db;
import 'package:minigl/models/budget_model.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final db.AppDatabase database;
  final Logger _logger = Logger(); // Logger instance

  BudgetBloc(this.database) : super(BudgetInitial()) {
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
      _logger.i("Loading budgets from database...");

      final dbBudgets = await database.getAllBudgets();

      // Convert from database model (Drift) to app model
      final budgets =
          dbBudgets
              .map(
                (dbBudget) => Budget(
                  id: dbBudget.id,
                  name: dbBudget.name, // ✅ Make sure this exists in DbBudget
                  category: dbBudget.category, // ✅ Ensure category is mapped
                  amount: dbBudget.amount,
                  spent: dbBudget.spent, // Ensure you have 'spent'
                  startDate: dbBudget.startDate, // ✅ Ensure startDate exists
                  endDate: dbBudget.endDate,
                  recurrence:
                      BudgetRecurrence.values[dbBudget
                          .recurrence], // ✅ Ensure recurrence exists
                ),
              )
              .toList();

      emit(BudgetLoaded(budgets));
      _logger.i("Budgets loaded successfully: ${budgets.length} found.");
    } catch (e, stacktrace) {
      _logger.e("Failed to delete budget", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to load budgets."));
    }
  }

  Future<void> _onAddBudget(AddBudget event, Emitter<BudgetState> emit) async {
    try {
      _logger.i("Adding new budget for category: ${event.budget.category}");
      await database.insertBudget(
        db.BudgetsCompanion.insert(
          name: event.budget.name, // ✅ Add name
          category: event.budget.category,
          amount: event.budget.amount,
          startDate: event.budget.startDate, // ✅ Add startDate
          recurrence:
              event.budget.recurrence.index, // ✅ Store recurrence as int
        ),
      );

      _logger.i("Budget added successfully.");
      add(LoadBudgets());
    } catch (e, stacktrace) {
      _logger.e("Failed to delete budget", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to add budget."));
    }
  }

  Future<void> _onUpdateSpent(
    UpdateSpent event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      _logger.i(
        "Updating spent amount for budget ID: ${event.budgetId} to ${event.newSpent}",
      );
      await database.updateBudgetSpent(event.budgetId, event.newSpent);
      _logger.i("Spent amount updated successfully.");
      add(LoadBudgets());
    } catch (e, stacktrace) {
      _logger.e("Failed to delete budget", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to update budget."));
    }
  }

  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      _logger.w("Deleting budget ID: ${event.budgetId}");
      await database.deleteBudget(event.budgetId);
      _logger.w("Budget deleted successfully.");
      add(LoadBudgets());
    } catch (e, stacktrace) {
      _logger.e("Failed to delete budget", error: e, stackTrace: stacktrace);
      emit(BudgetError("Failed to delete budget."));
    }
  }
}
