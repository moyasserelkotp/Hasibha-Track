import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/const/colors.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<String, double> categoryBreakdown;

  const SpendingPieChart({super.key, required this.categoryBreakdown});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Generate colors for categories
    final colors = [
      AppColors.error,
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      AppColors.success,
      AppColors.info,
    ];

    final sections = categoryBreakdown.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final color = colors[index % colors.length];
      
      return PieChartSectionData(
        value: category.value,
        title: '\$${category.value.toStringAsFixed(0)}',
        color: color,
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
