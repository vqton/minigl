// lib/views/category_management_page.dart
import 'package:flutter/material.dart';
import 'package:minigl/models/transaction.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final _nameController = TextEditingController();
  TransactionType _selectedType = TransactionType.expense;
  String _selectedColor = '#FF0000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Categories')),
      body: Column(
        children: [
          // Add category form
          // Category list with edit/delete options
        ],
      ),
    );
  }
}