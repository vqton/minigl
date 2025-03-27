import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232F3E), // Amazon deep blue
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFFFFA41C), // Amazon orange
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.white54),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard, size: 28), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.list, size: 28), label: "Transactions"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet, size: 28), label: "Budgets"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart, size: 28), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.menu, size: 28), label: "More"),
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
                context.go('/reports');
                break;
              case 4:
                _showMoreOptions(context);
                break;
            }
          }
        },
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.savings),
              title: Text("Savings"),
              onTap: () => context.go('/savings'),
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text("Accounts"),
              onTap: () => context.go('/accounts'),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Manage Categories"), // Added category management
              onTap: () => context.go('/categories'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () => context.go('/settings'),
            ),
          ],
        );
      },
    );
  }
}
