import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF232F3E), // Amazon deep blue
      selectedItemColor: const Color(0xFFFFA41C), // Amazon orange
      unselectedItemColor: Colors.white70, // Lighter white for unselected items
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(color: Colors.white54),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Transactions"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Budgets"),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
      ],
      onTap: (index) {
        if (index != currentIndex) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/transactions');
              break;
            case 2:
              context.go('/budget');
              break;
            case 3:
              context.go('/categories');
              break;
          }
        }
      },
    );
  }
}
