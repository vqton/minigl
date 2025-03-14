import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/bloc/transaction/transaction_event.dart';
import 'package:minigl/widgets/transactions/edit_transaction_dialog.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_state.dart';

class TransactionList extends StatelessWidget {
  final String filterType;
  final String sortOption;

  const TransactionList({
    super.key,
    required this.filterType,
    required this.sortOption,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionInitial) {
          context.read<TransactionBloc>().add(LoadTransactions());
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionLoaded) {
          var transactions = state.transactions;

          if (filterType != "all") {
            transactions = transactions.where((t) => t.type == filterType).toList();
          }

          if (sortOption == "amount") {
            transactions.sort((a, b) => b.amount.compareTo(a.amount));
          } else if (sortOption == "type") {
            transactions.sort((a, b) => a.type.compareTo(b.type));
          } else {
            transactions.sort((a, b) => b.date.compareTo(a.date));
          }

          if (transactions.isEmpty) {
            return const Center(child: Text("No transactions found."));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction.category),
                subtitle: Text(
                  "${transaction.type == "income" ? "+" : "-"}\$${transaction.amount} | ${transaction.date.toLocal()}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => showEditTransactionDialog(context, transaction),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => confirmDeleteTransaction(context, transaction.id),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is TransactionError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return Container();
      },
    );
  }
}