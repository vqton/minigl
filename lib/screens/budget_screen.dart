import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/widgets/dashboard/bottom_navigation.dart';
import 'package:minigl/widgets/budget/add_budget_dialog.dart'; // ✅ Import the new dialog widget
import '../bloc/budget/budget_bloc.dart';
import '../bloc/budget/budget_event.dart';
import '../bloc/budget/budget_state.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budgets")),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state is BudgetInitial) {
            context.read<BudgetBloc>().add(LoadBudgets());
            return const Center(child: CircularProgressIndicator());
          } else if (state is BudgetLoaded) {
            return ListView.builder(
              itemCount: state.budgets.length,
              itemBuilder: (context, index) {
                final budget = state.budgets[index];
                return ListTile(
                  title: Text(budget.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category: ${budget.category}"),
                      Text("Amount: \$${budget.amount.toStringAsFixed(2)}"),
                      Text("Spent: \$${budget.spent.toStringAsFixed(2)}"),
                      Text("Recurrence: ${budget.recurrence.toString().split('.').last}"),
                      Text("Period: ${_formatDate(budget.startDate)} - ${_formatDate(budget.endDate)}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<BudgetBloc>().add(DeleteBudget(budget.id));
                    },
                  ),
                );
              },
            );
          } else if (state is BudgetError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddBudgetDialog(), // ✅ Use the new widget
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
