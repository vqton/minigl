import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/bloc/budget/budget_bloc.dart';
import 'package:minigl/bloc/budget/budget_event.dart';
import 'package:minigl/bloc/category/category_bloc.dart';
import 'package:minigl/bloc/category/category_event.dart';
import 'package:minigl/bloc/category/category_state.dart';
import 'package:minigl/models/budget_model.dart';

class AddBudgetDialog extends StatefulWidget {
  const AddBudgetDialog({super.key});

  @override
  _AddBudgetDialogState createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  BudgetRecurrence selectedRecurrence = BudgetRecurrence.monthly;
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 30)),
  );
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Ensure categories are loaded when the dialog opens
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        List<String> categoryNames = [];

        if (categoryState is CategoryLoaded) {
          categoryNames = categoryState.categories.map((c) => c.name).toList();
          if (selectedCategory == null && categoryNames.isNotEmpty) {
            selectedCategory = categoryNames.first;
          }
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Create New Budget",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Budget Name Field
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Budget Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items:
                          categoryNames.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      validator:
                          (value) =>
                              value == null ? 'Please select a category' : null,
                    ),
                    const SizedBox(height: 16),

                    // Amount Field
                    TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter an amount';
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Recurrence Picker
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recurrence",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<BudgetRecurrence>(
                          value: selectedRecurrence,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items:
                              BudgetRecurrence.values.map((recurrence) {
                                return DropdownMenuItem(
                                  value: recurrence,
                                  child: Text(
                                    recurrence.toString().split('.').last,
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRecurrence = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Date Range Picker
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Budget Period",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "From",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(_formatDate(selectedDateRange.start)),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward, size: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "To",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(_formatDate(selectedDateRange.end)),
                                  ],
                                ),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  selectedCategory != null) {
                                final newBudget = Budget(
                                  name: nameController.text,
                                  category: selectedCategory!,
                                  amount: double.parse(amountController.text),
                                  spent: 0,
                                  recurrenceIndex: selectedRecurrence.index,
                                  startDate: selectedDateRange.start,
                                  endDate: selectedDateRange.end,
                                );
                                context.read<BudgetBloc>().add(
                                  AddBudget(newBudget),
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Create Budget"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
