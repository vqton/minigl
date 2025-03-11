import 'package:minigl/models/transaction.dart';

abstract class TransactionEvent {}
class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  AddTransaction(this.transaction);
}
class DeleteTransaction extends TransactionEvent {
  final String transactionId;
  DeleteTransaction(this.transactionId);
}
class LoadTransactions extends TransactionEvent {}