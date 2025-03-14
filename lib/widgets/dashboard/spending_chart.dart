import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // Soft shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Smooth rounded corners
      ),
      color: Colors.blueGrey[900], // Amazon-like deep background
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Spending by Category",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Contrast text
              ),
            ),
            const SizedBox(height: 16), 
            AspectRatio(
              aspectRatio: 1.2,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2, // Smaller space between slices
                  centerSpaceRadius: 50, // Amazon-like minimal center space
                  sections: _chartSections(),
                ),
              ),
            ),
            const SizedBox(height: 16), 
            _buildLegend(), // Amazon-style legend
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _chartSections() {
    return [
      _pieSection(40, "Food", Colors.blue.shade300, Colors.blue.shade800),
      _pieSection(30, "Transport", Colors.orange.shade300, Colors.orange.shade800),
      _pieSection(30, "Bills", Colors.red.shade300, Colors.red.shade800),
    ];
  }

  PieChartSectionData _pieSection(double value, String title, Color start, Color end) {
    return PieChartSectionData(
      value: value,
      title: title,
      radius: 80, // Larger pie slices
      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      color: LinearGradient(
        colors: [start, end], // Gradient effect
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).colors.first,
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _legendItem(Colors.blue.shade300, "Food"),
        _legendItem(Colors.orange.shade300, "Transport"),
        _legendItem(Colors.red.shade300, "Bills"),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }
}
