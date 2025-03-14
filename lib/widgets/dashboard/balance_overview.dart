import 'package:flutter/material.dart';

class BalanceOverview extends StatelessWidget {
  const BalanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme

    return Card(
      color: theme.colorScheme.primary, // Deep blue background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4, // Subtle shadow
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Balance",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white, // White text for contrast
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "\$1,200",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary, // Amazon Orange
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Income: \$2000 | Expenses: \$800",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
