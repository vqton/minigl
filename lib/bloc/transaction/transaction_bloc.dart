import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/bloc/transaction/transaction_state.dart';
import 'package:minigl/models/transaction_model.dart';

import 'transaction_event.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  List<Transaction> _transactions = [];

  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);

    // Load transactions when the BLoC is initialized
    add(LoadTransactions());
  }

  void _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) {
    emit(TransactionLoaded(List.from(_transactions)));
  }

  void _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) {
    _transactions.add(event.transaction);
    emit(TransactionLoaded(List.from(_transactions)));
  }

  void _onUpdateTransaction(UpdateTransaction event, Emitter<TransactionState> emit) {
    _transactions = _transactions.map((transaction) {
      return transaction.id == event.transaction.id ? event.transaction : transaction;
    }).toList();
    emit(TransactionLoaded(List.from(_transactions)));
  }

  void _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) {
    _transactions.removeWhere((transaction) => transaction.id == event.transactionId);
    emit(TransactionLoaded(List.from(_transactions)));
  }
}