import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.grey[900], // Dark gray background for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildTypeIcon(),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white, // White text for the title
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          DateFormat('MMM d, yyyy').format(transaction.date),
          style: TextStyle(
            color: Colors.grey[400], // Light gray text for the date
          ),
        ),
        trailing: Text(
          CurrencyFormatter.format(transaction.amount),
          style: TextStyle(
            color: transaction.type == TransactionType.income 
                ? Colors.green // Green for income
                : Colors.red, // Red for expenses
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: transaction.type == TransactionType.income 
            ? Colors.green.withOpacity(0.2) // Light green background for income
            : Colors.red.withOpacity(0.2), // Light red background for expenses
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        transaction.type == TransactionType.income 
            ? Icons.arrow_upward 
            : Icons.arrow_downward,
        color: transaction.type == TransactionType.income 
            ? Colors.green // Green icon for income
            : Colors.red, // Red icon for expenses
        size: 24,
      ),
    );
  }
}