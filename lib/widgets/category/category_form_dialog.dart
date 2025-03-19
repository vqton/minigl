import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:minigl/bloc/category/category_bloc.dart';
import 'package:minigl/bloc/category/category_event.dart';
import 'package:minigl/models/category_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji_picker;

class CategoryFormDialog extends StatefulWidget {
  final Category? category;

  const CategoryFormDialog({super.key, this.category});

  @override
  _CategoryFormDialogState createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _type = "expense";
  String _icon = "❓";
  Color _selectedColor = Colors.blueAccent;
  final Logger logger = Logger();

  final Map<String, Color> _defaultColors = {
    "income": Colors.green,
    "expense": Colors.red,
  };

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _type = widget.category!.type;
      _icon = widget.category?.icon ?? "❓";
      _selectedColor = Color(
        widget.category?.color ?? _defaultColors[_type]!.toARGB32(),
      );
      _budgetController.text = widget.category?.budget?.toString() ?? '';
    } else {
      _selectedColor = _defaultColors[_type]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ), // Limits height
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Prevents unnecessary space usage
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category == null ? "Add Category" : "Edit Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Category Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                      _selectedColor = _defaultColors[_type]!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items:
                      ["income", "expense"].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Budget Limit (Optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Select Icon:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: _pickIcon,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _selectedColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _selectedColor.withAlpha(50),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(_icon, style: TextStyle(fontSize: 30)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Select Color:"),
                Wrap(
                  spacing: 8,
                  children:
                      Colors.primaries.map((color) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 14,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade800,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.category == null
                          ? "Add Category"
                          : "Update Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickIcon() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: emoji_picker.EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() => _icon = emoji.emoji);
              logger.d("Selected icon: $_icon");
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _saveCategory() {
    if (_nameController.text.trim().isEmpty) return;
    final category = Category(
      id: widget.category?.id ?? 0,
      name: _nameController.text.trim(),
      type: _type,
      icon: _icon,
      color: _selectedColor.toARGB32(),
      budget: double.tryParse(_budgetController.text.trim()),
    );
    context.read<CategoryBloc>().add(
      widget.category == null
          ? AddCategory(category)
          : UpdateCategory(category),
    );
    Navigator.of(context).pop();
  }
}
