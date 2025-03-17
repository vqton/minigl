// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/bloc/category/category_bloc.dart';
import 'package:minigl/bloc/category/category_event.dart';
import 'package:minigl/models/category_model.dart';
import 'package:logger/logger.dart';

class CategoryFormDialog extends StatefulWidget {
  final Category? category;

  const CategoryFormDialog({Key? key, this.category}) : super(key: key);

  @override
  _CategoryFormDialogState createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _type = "expense";
  // Create a logger instance
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _type = widget.category!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Category Name"),
          ),
          DropdownButton<String>(
            value: _type,
            onChanged: (value) {
              setState(() {
                _type = value!;
              });
              logger.d("Dropdown selected type: $_type"); // Log type changes
            },
            items:
                ["income", "expense"].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
          ),
          ElevatedButton(
            onPressed: _saveCategory,
            child: Text(
              widget.category == null ? "Add Category" : "Update Category",
            ),
          ),
        ],
      ),
    );
  }

  void _saveCategory() {
    if (_nameController.text.trim().isEmpty) {
       logger.w("Category name is empty, aborting save.");
      return;
    }

    final category = Category(
      id: widget.category?.id ?? 0, // ID for updates (assuming 0 for new)
      name: _nameController.text.trim(),
      type: _type,
      icon:
          widget.category?.icon ??  "", // Make sure you handle the icon properly
    );

    if (widget.category == null) {
      context.read<CategoryBloc>().add(AddCategory(category));
    } else {
      context.read<CategoryBloc>().add(UpdateCategory(category));
    }

    Navigator.of(context).pop(); // Close the dialog after saving
  }
}
