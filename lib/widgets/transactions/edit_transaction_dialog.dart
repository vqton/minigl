import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../models/transaction_model.dart';

void showEditTransactionDialog(BuildContext context, Transaction transaction) {
  final categoryController = TextEditingController(text: transaction.category);
  final amountController = TextEditingController(text: transaction.amount.toString());
  String transactionType = transaction.type;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Transaction"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: transactionType,
              onChanged: (value) {
                transactionType = value!;
              },
              items: const [
                DropdownMenuItem(value: "income", child: Text("Income")),
                DropdownMenuItem(value: "expense", child: Text("Expense")),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedTransaction = Transaction(
                id: transaction.id,
                category: categoryController.text,
                amount: double.parse(amountController.text),
                date: transaction.date,
                type: transactionType,
              );

              context.read<TransactionBloc>().add(UpdateTransaction(updatedTransaction));
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      );
    },
  );
}

void confirmDeleteTransaction(BuildContext context, int transactionId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TransactionBloc>().add(DeleteTransaction(transactionId));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}