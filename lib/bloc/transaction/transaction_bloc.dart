import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:objectbox/objectbox.dart';
import 'package:logger/logger.dart';
import 'package:minigl/models/transaction_model.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final Store store;
  final Logger _logger = Logger();

  TransactionBloc(this.store) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);

    // Load transactions when the BLoC is initialized
    add(LoadTransactions());
  }

  void _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) {
    try {
      final box = store.box<Transaction>();
      final transactions = box.getAll();
      _logger.i("Loaded ${transactions.length} transactions from ObjectBox.");
      emit(TransactionLoaded(transactions));
    } catch (e, stacktrace) {
      _logger.e("Failed to load transactions", error: e, stackTrace: stacktrace);
      emit(TransactionError("Failed to load transactions."));
    }
  }

  void _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) {
    try {
      final box = store.box<Transaction>();
      final newTransaction = event.transaction;
      box.put(newTransaction);
      _logger.i("Transaction added: ${newTransaction.id}");
      add(LoadTransactions());
    } catch (e, stacktrace) {
      _logger.e("Failed to add transaction", error: e, stackTrace: stacktrace);
      emit(TransactionError("Failed to add transaction."));
    }
  }

  void _onUpdateTransaction(UpdateTransaction event, Emitter<TransactionState> emit) {
    try {
      final box = store.box<Transaction>();
      final updatedTransaction = event.transaction;
      box.put(updatedTransaction);
      _logger.i("Transaction updated: ${updatedTransaction.id}");
      add(LoadTransactions());
    } catch (e, stacktrace) {
      _logger.e("Failed to update transaction", error: e, stackTrace: stacktrace);
      emit(TransactionError("Failed to update transaction."));
    }
  }

  void _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) {
    try {
      final box = store.box<Transaction>();
      box.remove(event.transactionId);
      _logger.w("Transaction deleted: ${event.transactionId}");
      add(LoadTransactions());
    } catch (e, stacktrace) {
      _logger.e("Failed to delete transaction", error: e, stackTrace: stacktrace);
      emit(TransactionError("Failed to delete transaction."));
    }
  }
}
