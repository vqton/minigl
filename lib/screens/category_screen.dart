import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/widgets/category/category_form_dialog.dart';
import '../../../bloc/category/category_bloc.dart';
import '../../../bloc/category/category_event.dart';
import '../../../bloc/category/category_state.dart';
import '../../../models/category_model.dart';


class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryInitial) {
            context.read<CategoryBloc>().add(LoadCategories());
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return ListTile(
                  leading: Text(category.icon, style: TextStyle(fontSize: 24)),
                  title: Text(category.name),
                  subtitle: Text(category.type.toUpperCase()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showCategoryFormDialog(context, category: category);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<CategoryBloc>().add(
                            DeleteCategory(category.id),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryFormDialog(context),
        child: Icon(Icons.add),
      ),
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
}
