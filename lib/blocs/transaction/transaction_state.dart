import 'package:minigl/models/transaction.dart';

abstract class TransactionState {}
class TransactionLoading extends TransactionState {}
class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final double balance;
  TransactionLoaded(this.transactions, this.balance);
}
class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}