import 'package:equatable/equatable.dart';
import '../../models/transaction_model.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state
class TransactionInitial extends TransactionState {}

// Transactions Loaded
class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  TransactionLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

// Error State
class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
