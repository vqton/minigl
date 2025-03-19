import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/widgets/dashboard/bottom_navigation.dart';
import '../bloc/budget/budget_bloc.dart';
import '../bloc/budget/budget_event.dart';
import '../bloc/budget/budget_state.dart';
import '../models/budget_model.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Budgets")),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state is BudgetInitial) {
            context.read<BudgetBloc>().add(LoadBudgets());
            return Center(child: CircularProgressIndicator());
          } else if (state is BudgetLoaded) {
            return ListView.builder(
              itemCount: state.budgets.length,
              itemBuilder: (context, index) {
                final budget = state.budgets[index];
                return ListTile(
                  title: Text(budget.category),
                  subtitle: Text(
                    "Budget: \$${budget.amount} | Spent: \$${budget.spent}",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
          _showAddBudgetDialog(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 2),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Budget"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newBudget = Budget(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name:
                      categoryController
                          .text, // ✅ Use category as name (or ask user)
                  category: categoryController.text,
                  amount: double.parse(amountController.text),
                  spent: 0,
                  startDate: DateTime.now(),
                );
                context.read<BudgetBloc>().add(AddBudget(newBudget));
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
