import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Overview
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Balance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text("\$12,450.00", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Income & Expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard("Income", "\$5,600.00", Colors.green),
                _buildSummaryCard("Expenses", "\$3,200.00", Colors.red),
              ],
            ),

            SizedBox(height: 16),

            // Recent Transactions
            Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildTransactionItem("Groceries", "-\$120.00", Colors.red),
                  _buildTransactionItem("Salary", "+\$2,000.00", Colors.green),
                  _buildTransactionItem("Electric Bill", "-\$60.00", Colors.red),
                ],
              ),
            ),

            // Quick Actions
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton(context, "Transactions", "/transactions"),
                _buildNavButton(context, "Budget", "/budget"),
                _buildNavButton(context, "Categories", "/categories"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Summary Cards
  Widget _buildSummaryCard(String title, String amount, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text(amount, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Transaction Items
  Widget _buildTransactionItem(String title, String amount, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }

  // Widget for Navigation Buttons
  Widget _buildNavButton(BuildContext context, String title, String route) {
    return ElevatedButton(
      onPressed: () => context.go(route),
      child: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
