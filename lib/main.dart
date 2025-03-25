import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:minigl/database/objectbox.dart';
import 'package:minigl/objectbox.g.dart';
import 'core/theme.dart';
import 'bloc/transaction/transaction_bloc.dart';
import 'bloc/budget/budget_bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'core/app_router.dart';

final Logger _logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  _logger.i("Initializing ObjectBox database...");
  final objectBox = await ObjectBox.init();
  _logger.i("ObjectBox initialized successfully.");

  runApp(MyApp(store: objectBox.store));
}

class MyApp extends StatelessWidget {
  final Store store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    _logger.i("Starting app and initializing BLoCs...");

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            _logger.i("Initializing TransactionBloc...");
            return TransactionBloc(store);
          },
        ),
        BlocProvider(
          create: (_) {
            _logger.i("Initializing BudgetBloc...");
            return BudgetBloc(store);
          },
        ),
        BlocProvider(
          create: (_) {
            _logger.i("Initializing CategoryBloc...");
            return CategoryBloc(store);
          },
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
