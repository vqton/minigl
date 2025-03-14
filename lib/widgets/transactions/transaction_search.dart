import 'package:flutter/material.dart';
import 'package:minigl/bloc/transaction/transaction_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
// import '../models/transaction_model.dart';

class TransactionSearch extends SearchDelegate<String> {
  final TransactionBloc transactionBloc;

  TransactionSearch(this.transactionBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ""),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final transactions = (transactionBloc.state as TransactionLoaded).transactions;
    final suggestions = transactions
        .where((t) => t.category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].category),
          onTap: () => close(context, suggestions[index].category),
        );
      },
    );
  }
}