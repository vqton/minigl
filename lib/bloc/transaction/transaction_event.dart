import 'package:equatable/equatable.dart';
import '../../models/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Load transactions
class LoadTransactions extends TransactionEvent {}

// Add a transaction
class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

// Update transaction
class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;
  UpdateTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

// Delete transaction
class DeleteTransaction extends TransactionEvent {
  final int transactionId;
  DeleteTransaction(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}
