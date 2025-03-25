import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:minigl/screens/404_screen.dart';
import 'package:minigl/widgets/error_page_builder.dart';
import '../screens/dashboard_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/budget_screen.dart';
import '../screens/category_screen.dart';

final Logger _logger = Logger();

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        _logger.i("Navigating to DashboardScreen");
        return DashboardScreen();
      },
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) {
        _logger.i("Navigating to TransactionScreen");
        return TransactionScreen();
      },
    ),
    GoRoute(
      path: '/budget',
      builder: (context, state) {
        _logger.i("Navigating to BudgetScreen");
        return BudgetScreen();
      },
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) {
        _logger.i("Navigating to CategoryScreen");
        return CategoryScreen();
      },
    ),
    GoRoute(
      path: '/404',
      builder: (context, state) {
        _logger.w("Navigating to 404 - NotFoundPage");
        return NotFoundPage();
      },
    ),
  ],
  errorBuilder: (context, state) {
    _logger.e("Navigation error: ${state.error}");
    return ErrorPage(message: state.error.toString());
  },
);
