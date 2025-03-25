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
        onPressed: () => _showAddBudgetDialog(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showAddBudgetDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    BudgetRecurrence selectedRecurrence = BudgetRecurrence.monthly;
    DateTimeRange selectedDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 30)),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Budget"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Budget Name"),
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: "Category"),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: "Amount"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<BudgetRecurrence>(
                      value: selectedRecurrence,
                      items: BudgetRecurrence.values.map((recurrence) {
                        return DropdownMenuItem(
                          value: recurrence,
                          child: Text(recurrence.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedRecurrence = value!);
                      },
                      decoration: const InputDecoration(labelText: "Recurrence"),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final pickedRange = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          initialDateRange: selectedDateRange,
                        );
                        if (pickedRange != null) {
                          setState(() => selectedDateRange = pickedRange);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 8),
                            Text(
                              "${_formatDate(selectedDateRange.start)} - ${_formatDate(selectedDateRange.end)}",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty || 
                        categoryController.text.isEmpty || 
                        amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    final newBudget = Budget(
                      name: nameController.text,
                      category: categoryController.text,
                      amount: double.parse(amountController.text),
                      spent: 0,
                      recurrenceIndex: selectedRecurrence.index,
                      startDate: selectedDateRange.start,
                      endDate: selectedDateRange.end,
                    );

                    context.read<BudgetBloc>().add(AddBudget(newBudget));
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}