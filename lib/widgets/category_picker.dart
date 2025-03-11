// lib/widgets/category_picker.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/blocs/category/category_event.dart';
import 'package:minigl/blocs/category/category_state.dart';
import '../blocs/category/category_bloc.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryPicker extends StatefulWidget {
  final Function(Category) onCategorySelected;

  const CategoryPicker({super.key, required this.onCategorySelected});

  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
  }

  void _showCategoryPickerDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is CategoryLoadSuccess) {
              return ListView(
                controller: scrollController,
                children: [
                  // Category list
                  ...state.categories.map((category) => ListTile(
                    leading: CircleAvatar(backgroundColor: Color(category.color)),
                    title: Text(category.name),
                    onTap: () {
                      setState(() => _selectedCategory = category);
                      widget.onCategorySelected(category);
                      Navigator.pop(context);
                    },
                  )),
                  
                  // Add new category button
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Create New Category'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CategoryManagementPage()),
                    ),
                  ),
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryLoadSuccess && _selectedCategory == null) {
          _selectedCategory = state.categories.firstWhere(
            (c) => c.type == TransactionType.expense,
            orElse: () => state.categories.first,
          );
        }
      },
      child: InkWell(
        onTap: _showCategoryPickerDialog,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (_selectedCategory != null) {
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(_selectedCategory!.color),
                      radius: 12,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _selectedCategory!.name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            
            return Container(
              padding: EdgeInsets.all(12),
              child: Text('Select Category'),
            );
          },
        ),
      ),
    );
  }
}