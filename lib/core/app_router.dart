import 'package:go_router/go_router.dart';

import '../screens/dashboard_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/budget_screen.dart';
import '../screens/category_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => DashboardScreen(), // Dashboard is now the default
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => TransactionScreen(),
    ),
    GoRoute(
      path: '/budget',
      builder: (context, state) => BudgetScreen(),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => CategoryScreen(),
    ),
  ],
);
