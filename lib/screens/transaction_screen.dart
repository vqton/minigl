// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:minigl/widgets/dashboard/bottom_navigation.dart';
// import '../bloc/transaction/transaction_bloc.dart';
// import '../bloc/transaction/transaction_event.dart';
// import '../bloc/transaction/transaction_state.dart';
// import '../models/transaction_model.dart';

// class TransactionScreen extends StatefulWidget {
//   const TransactionScreen({super.key});

//   @override
//   _TransactionScreenState createState() => _TransactionScreenState();
// }

// class _TransactionScreenState extends State<TransactionScreen> {
//   String searchQuery = "";
//   String filterType = "all";
//   String sortOption = "date";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Transactions"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: TransactionSearch(context.read<TransactionBloc>()),
//               );
//             },
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               setState(() {
//                 sortOption = value;
//               });
//             },
//             itemBuilder:
//                 (context) => [
//                   const PopupMenuItem(
//                     value: "date",
//                     child: Text("Sort by Date"),
//                   ),
//                   const PopupMenuItem(
//                     value: "amount",
//                     child: Text("Sort by Amount"),
//                   ),
//                   const PopupMenuItem(
//                     value: "type",
//                     child: Text("Sort by Type"),
//                   ),
//                 ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildFilterOptions(),
//           Expanded(child: _buildTransactionList()),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddTransactionDialog(context),
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomNavigation(currentIndex: 1),
//     );
//   }

//   Widget _buildFilterOptions() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           DropdownButton<String>(
//             value: filterType,
//             onChanged: (value) {
//               setState(() {
//                 filterType = value!;
//               });
//             },
//             items: const [
//               DropdownMenuItem(value: "all", child: Text("All")),
//               DropdownMenuItem(value: "income", child: Text("Income")),
//               DropdownMenuItem(value: "expense", child: Text("Expense")),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionList() {
//     return BlocBuilder<TransactionBloc, TransactionState>(
//       builder: (context, state) {
//         if (state is TransactionInitial) {
//           context.read<TransactionBloc>().add(LoadTransactions());
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is TransactionLoaded) {
//           var transactions = state.transactions;

//           if (filterType != "all") {
//             transactions =
//                 transactions.where((t) => t.type == filterType).toList();
//           }

//           if (sortOption == "amount") {
//             transactions.sort((a, b) => b.amount.compareTo(a.amount));
//           } else if (sortOption == "type") {
//             transactions.sort((a, b) => a.type.compareTo(b.type));
//           } else {
//             transactions.sort((a, b) => b.date.compareTo(a.date));
//           }

//           if (transactions.isEmpty) {
//             return const Center(child: Text("No transactions found."));
//           }

//           return ListView.builder(
//             itemCount: transactions.length,
//             itemBuilder: (context, index) {
//               final transaction = transactions[index];
//               return ListTile(
//                 title: Text(transaction.category),
//                 subtitle: Text(
//                   "${transaction.type == "income" ? "+" : "-"}\$${transaction.amount} | ${transaction.date.toLocal()}",
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       onPressed:
//                           () =>
//                               _showEditTransactionDialog(context, transaction),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed:
//                           () => _confirmDeleteTransaction(
//                             context,
//                             transaction.id,
//                           ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         } else if (state is TransactionError) {
//           return Center(child: Text("Error: ${state.message}"));
//         }
//         return Container();
//       },
//     );
//   }

//   void _showAddTransactionDialog(BuildContext context) {
//     final categoryController = TextEditingController();
//     final amountController = TextEditingController();
//     String transactionType = "income"; // Default type

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Add Transaction"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: categoryController,
//                 decoration: const InputDecoration(labelText: "Category"),
//               ),
//               TextField(
//                 controller: amountController,
//                 decoration: const InputDecoration(labelText: "Amount"),
//                 keyboardType: TextInputType.number,
//               ),
//               DropdownButton<String>(
//                 value: transactionType,
//                 onChanged: (value) {
//                   transactionType = value!;
//                 },
//                 items: const [
//                   DropdownMenuItem(value: "income", child: Text("Income")),
//                   DropdownMenuItem(value: "expense", child: Text("Expense")),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (categoryController.text.isEmpty ||
//                     amountController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Please fill in all fields.")),
//                   );
//                   return;
//                 }

//                 final amount = double.tryParse(amountController.text);
//                 if (amount == null || amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Please enter a valid amount."),
//                     ),
//                   );
//                   return;
//                 }

//                 final newTransaction = Transaction(
//                   id:
//                       DateTime.now()
//                           .millisecondsSinceEpoch, // Unique ID based on timestamp
//                   category: categoryController.text,
//                   amount: amount,
//                   date: DateTime.now(),
//                   type: transactionType,
//                 );

//                 context.read<TransactionBloc>().add(
//                   AddTransaction(newTransaction),
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditTransactionDialog(
//     BuildContext context,
//     Transaction transaction,
//   ) {
//     final categoryController = TextEditingController(
//       text: transaction.category,
//     );
//     final amountController = TextEditingController(
//       text: transaction.amount.toString(),
//     );
//     String transactionType = transaction.type;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Edit Transaction"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: categoryController,
//                 decoration: const InputDecoration(labelText: "Category"),
//               ),
//               TextField(
//                 controller: amountController,
//                 decoration: const InputDecoration(labelText: "Amount"),
//                 keyboardType: TextInputType.number,
//               ),
//               DropdownButton<String>(
//                 value: transactionType,
//                 onChanged: (value) {
//                   transactionType = value!;
//                 },
//                 items: const [
//                   DropdownMenuItem(value: "income", child: Text("Income")),
//                   DropdownMenuItem(value: "expense", child: Text("Expense")),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final updatedTransaction = Transaction(
//                   id: transaction.id,
//                   category: categoryController.text,
//                   amount: double.parse(amountController.text),
//                   date: transaction.date,
//                   type: transactionType,
//                 );
//                 context.read<TransactionBloc>().add(
//                   UpdateTransaction(updatedTransaction),
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Update"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _confirmDeleteTransaction(BuildContext context, int transactionId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Confirm Deletion"),
//           content: const Text(
//             "Are you sure you want to delete this transaction?",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 context.read<TransactionBloc>().add(
//                   DeleteTransaction(transactionId),
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class TransactionSearch extends SearchDelegate<String> {
//   final TransactionBloc transactionBloc;

//   TransactionSearch(this.transactionBloc);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () => close(context, ""),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final transactions =
//         (transactionBloc.state as TransactionLoaded).transactions;
//     final suggestions =
//         transactions
//             .where(
//               (t) => t.category.toLowerCase().contains(query.toLowerCase()),
//             )
//             .toList();

//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(suggestions[index].category),
//           onTap: () => close(context, suggestions[index].category),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/widgets/dashboard/bottom_navigation.dart';
import '../bloc/transaction/transaction_bloc.dart';
import '../widgets/transactions/transaction_list.dart';
import '../widgets/transactions/filter_options.dart';
import '../widgets/transactions/transaction_search.dart';
import '../widgets/transactions/add_transaction_dialog.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String searchQuery = "";
  String filterType = "all";
  String sortOption = "date";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TransactionSearch(context.read<TransactionBloc>()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortOption = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "date", child: Text("Sort by Date")),
              const PopupMenuItem(value: "amount", child: Text("Sort by Amount")),
              const PopupMenuItem(value: "type", child: Text("Sort by Type")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          FilterOptions(
            filterType: filterType,
            onFilterChanged: (value) {
              setState(() {
                filterType = value;
              });
            },
          ),
          Expanded(
            child: TransactionList(
              filterType: filterType,
              sortOption: sortOption,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTransactionDialog(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 1),
    );
  }
}