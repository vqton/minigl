// lib/blocs/transaction/transaction_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:minigl/models/transaction.dart';
import 'package:minigl/services/transaction_service.dart';
import 'package:minigl/utils/logger.dart';

import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _service = TransactionService();

  TransactionBloc(TransactionService transactionService) : super(TransactionLoading()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    add(LoadTransactions()); // Initial load
  }

  // Calculate balance from transactions
  double _calculateBalance(List<Transaction> transactions) {
    return transactions.fold(0, (sum, t) => 
      t.type == TransactionType.income ? sum + t.amount : sum - t.amount);
  }

  // Load transactions handler
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    AppLogger.debug('Processing LoadTransactions event');
    emit(TransactionLoading());
    
    try {
      final transactions = await _service.getTransactions();
      final balance = _calculateBalance(transactions);
      emit(TransactionLoaded(transactions, balance));
      AppLogger.info('Transactions loaded successfully (${transactions.length} items)');
    } catch (e) {
      AppLogger.error('Failed to load transactions', e);
      emit(TransactionError('Failed to load transactions'));
    }
  }

  // Add transaction handler
  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    AppLogger.debug('Processing AddTransaction: ${event.transaction.title}');
    
    try {
      await _service.addTransaction(event.transaction);
      final transactions = await _service.getTransactions();
      final balance = _calculateBalance(transactions);
      emit(TransactionLoaded(transactions, balance));
      AppLogger.info('Transaction added successfully');
    } catch (e) {
      AppLogger.error('Failed to add transaction', e);
      emit(TransactionError('Failed to add transaction'));
    }
  }

  // Delete transaction handler
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    AppLogger.debug('Processing DeleteTransaction: ${event.transactionId}');
    
    try {
      await _service.deleteTransaction(event.transactionId);
      final transactions = await _service.getTransactions();
      final balance = _calculateBalance(transactions);
      emit(TransactionLoaded(transactions, balance));
      AppLogger.info('Transaction deleted successfully');
    } catch (e) {
      AppLogger.error('Failed to delete transaction', e);
      emit(TransactionError('Failed to delete transaction'));
    }
  }

  @override
  void onChange(Change<TransactionState> change) {
    super.onChange(change);
    AppLogger.debug('State changed: ${change.currentState} → ${change.nextState}');
  }

  @override
  void onTransition(Transition<TransactionEvent, TransactionState> transition) {
    super.onTransition(transition);
    AppLogger.debug('Transition: ${transition.event} → ${transition.nextState}');
  }
}