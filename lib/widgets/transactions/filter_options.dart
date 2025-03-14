import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  final String filterType;
  final Function(String) onFilterChanged;

  const FilterOptions({
    super.key,
    required this.filterType,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: filterType,
            onChanged: (value) {
              onFilterChanged(value!);
            },
            items: const [
              DropdownMenuItem(value: "all", child: Text("All")),
              DropdownMenuItem(value: "income", child: Text("Income")),
              DropdownMenuItem(value: "expense", child: Text("Expense")),
            ],
          ),
        ],
      ),
    );
  }
}