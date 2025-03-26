import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:minigl/widgets/dashboard/bottom_navigation.dart';
import 'package:minigl/widgets/exit_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF232F3E), // Amazon dark blue
        elevation: 1,
         actions: const [ExitButton()],
      ),
      backgroundColor: Color(0xFF232F3E), // Amazon dark blue
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 12),
            _buildAccountOverview(),
            const SizedBox(height: 12),
            _buildSpendingInsights(),
            const SizedBox(height: 12),
            _buildRecentTransactions(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF37475A), // Slightly lighter Amazon blue
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('Welcome, User', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          SizedBox(height: 6),
          Text('Balance: \$12,345.67', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
        ],
      ),
    );
  }

  Widget _buildAccountOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Accounts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildAccountCard('Checking', '\$5,000'),
            const SizedBox(width: 6),
            _buildAccountCard('Savings', '\$7,000'),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountCard(String title, String balance) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF485769), // Mid-tone Amazon blue
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
            const SizedBox(height: 2),
            Text(balance, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Spending Insights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 6),
        _buildPieChart(),
      ],
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 150,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(value: 40, color: Colors.blueAccent, title: 'Food', titleStyle: TextStyle(color: Colors.white, fontSize: 12)),
            PieChartSectionData(value: 30, color: Colors.orangeAccent, title: 'Bills', titleStyle: TextStyle(color: Colors.white, fontSize: 12)),
            PieChartSectionData(value: 30, color: Colors.greenAccent, title: 'Other', titleStyle: TextStyle(color: Colors.white, fontSize: 12)),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 30,
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xFF37475A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.tealAccent.withValues(alpha: 0.2),
                      child: Icon(Icons.shopping_bag, color: Colors.tealAccent),
                    ),
                    title: Text('Transaction ${index + 1}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('Category: Food | Date: 2023-10-${index + 1}', style: TextStyle(color: Colors.white70)),
                    trailing: Text(
                      index % 2 == 0 ? '-\$${(index + 1) * 10}' : '+\$${(index + 1) * 15}',
                      style: TextStyle(color: index % 2 == 0 ? Colors.redAccent : Colors.greenAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('View All', style: TextStyle(color: Colors.tealAccent)),
            ),
          ),
        ],
      ),
    );
  }
}
