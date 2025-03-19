import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:minigl/widgets/category/category_form_dialog.dart';
import 'package:minigl/widgets/dashboard/bottom_navigation.dart';
import '../../../bloc/category/category_bloc.dart';
import '../../../bloc/category/category_event.dart';
import '../../../bloc/category/category_state.dart';
import '../../../models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CategoryBloc>().add(LoadCategories());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return _buildEmptyCategories(context);
            }
            return _buildCategoryList(state.categories, context);
          } else if (state is CategoryError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryFormDialog(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildEmptyCategories(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category, size: 80, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              "No categories found!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showCategoryFormDialog(context),
              child: const Text("Add Category"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories, BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        logger.d(
          "Rendering category: ${category.name}, Type: ${category.type}, Color: ${category.color}",
        );

        return ListTile(
          leading: Text(
            category.icon ?? "📌",
            style: const TextStyle(fontSize: 24),
          ),
          title: Text(category.name),
          subtitle: Text(category.type.toUpperCase()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showCategoryFormDialog(context, category: category),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context, category),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryFormDialog(BuildContext context, {Category? category}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? "Add Category" : "Edit Category"),
        content: CategoryFormDialog(category: category),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text(
            "Are you sure you want to delete \"${category.name}\"?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<CategoryBloc>().add(DeleteCategory(category.id));
                if (Navigator.of(dialogContext).mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
