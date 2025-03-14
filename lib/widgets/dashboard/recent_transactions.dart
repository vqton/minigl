import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4, // Add shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 12), // Add spacing between title and list
              Expanded(
                child: ListView(
                  children: const [
                    _TransactionItem(
                      icon: Icons.shopping_cart,
                      title: "Grocery",
                      amount: "-\$50",
                      date: "Mar 10",
                      amountColor: Colors.red,
                    ),
                    _TransactionItem(
                      icon: Icons.attach_money,
                      title: "Salary",
                      amount: "+\$2000",
                      date: "Mar 9",
                      amountColor: Colors.green,
                    ),
                    _TransactionItem(
                      icon: Icons.electric_bolt,
                      title: "Electric Bill",
                      amount: "-\$100",
                      date: "Mar 8",
                      amountColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String date;
  final Color amountColor;

  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.amount,
    required this.date,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Theme.of(context).iconTheme.color),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(date, style: TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Text(
        amount,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: amountColor,
        ),
      ),
    );
  }
}