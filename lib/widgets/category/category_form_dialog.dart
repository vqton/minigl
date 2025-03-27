import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:minigl/bloc/category/category_bloc.dart';
import 'package:minigl/bloc/category/category_event.dart';
import 'package:minigl/models/category_model.dart';

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
  IconData _icon = Icons.category;
  Color _selectedColor = Colors.blueAccent;
  final Logger logger = Logger();

  final Map<String, Color> _defaultColors = {
    "income": Color(0xFF00A65A),
    "expense": Color(0xFFDD4B39),
  };

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _type = widget.category!.type;
      _icon = widget.category?.icon as IconData? ?? Icons.category;
      _selectedColor = Color(
        widget.category?.color ?? _defaultColors[_type]!.value,
      );
      _budgetController.text = widget.category?.budget?.toString() ?? '';
    } else {
      _selectedColor = _defaultColors[_type]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFormFields(),
              const SizedBox(height: 24),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.category == null ? "Create New Category" : "Edit Category",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF232F3E),
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey[300], thickness: 1),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: _amazonInputDecoration("Category Name"),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _type,
          onChanged:
              (value) => setState(() {
                _type = value!;
                _selectedColor = _defaultColors[_type]!;
              }),
          decoration: _amazonInputDecoration("Transaction Type"),
          items:
              ["income", "expense"].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type == "income" ? "Income" : "Expense",
                    style: TextStyle(
                      color:
                          _type == type ? Color(0xFF232F3E) : Colors.grey[600],
                    ),
                  ),
                );
              }).toList(),
          dropdownColor: Colors.white,
          style: TextStyle(color: Color(0xFF232F3E), fontSize: 14),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: _amazonInputDecoration("Monthly Budget (optional)"),
        ),
        const SizedBox(height: 24),
        _buildVisualSelector(),
      ],
    );
  }

  InputDecoration _amazonInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildVisualSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visual Style",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF232F3E),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildIconSelector(),
            const SizedBox(width: 24),
            _buildColorSelector(),
          ],
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Icon", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickIcon,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Icon(_icon, size: 28, color: _selectedColor),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _defaultColors.values.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              _selectedColor == color
                                  ? Color(0xFF232F3E)
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveCategory,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF9900),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          widget.category == null ? "Create Category" : "Save Changes",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
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
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose an Icon",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF232F3E),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                children:
                    [
                      Icons.shopping_basket,
                      Icons.account_balance_wallet,
                      Icons.directions_car,
                      Icons.restaurant,
                      Icons.home,
                      Icons.attach_money,
                      Icons.work,
                      Icons.health_and_safety,
                      Icons.school,
                      Icons.savings,
                    ].map((icon) {
                      return IconButton(
                        icon: Icon(icon, size: 24, color: _selectedColor),
                        onPressed: () {
                          setState(() => _icon = icon);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
              ),
            ],
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
      icon: _icon.codePoint.toString(),
      color: _selectedColor.value,
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
