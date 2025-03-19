import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/database/app_database.dart';
import 'core/theme.dart';
import 'bloc/transaction/transaction_bloc.dart';
import 'bloc/budget/budget_bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'core/app_router.dart'; // Importing the separate router file

void main() {
  final appDatabase = AppDatabase(); // Initialize the database
  runApp(MyApp(appDatabase: appDatabase));
}

class MyApp extends StatelessWidget {
  final dynamic appDatabase;

  const MyApp({super.key, required this.appDatabase});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TransactionBloc()),
        BlocProvider(create: (_) => BudgetBloc(appDatabase)),
        BlocProvider(create: (_) => CategoryBloc(appDatabase)),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Amazon-styled theme
        routerConfig: appRouter, // Uses the updated go_router configuration
      ),
    );
  }
}
