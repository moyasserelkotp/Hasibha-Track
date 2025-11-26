import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/analytics_data.dart';
import '../../../../shared/const/colors.dart';

class TrendBarChart extends StatelessWidget {
  final List<MonthlyData> monthlyTrends;

  const TrendBarChart({super.key, required this.monthlyTrends});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxValue() * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => isDark ? AppColors.surfaceDark : AppColors.surface,
              tooltipPadding: EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${rod.toY.toStringAsFixed(0)}',
                  TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < monthlyTrends.length) {
                    final month = monthlyTrends[value.toInt()].month.split(' ')[0];
                    return Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        month,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${(value / 1000).toStringAsFixed(0)}k',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _generateBarGroups(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark ? AppColors.borderDark.withOpacity(0.3) : AppColors.border.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  double _getMaxValue() {
    double max = 0;
    for (var data in monthlyTrends) {
      if (data.income > max) max = data.income;
      if (data.expense > max) max = data.expense;
    }
    return max;
  }

  List<BarChartGroupData> _generateBarGroups() {
    return monthlyTrends.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.income,
            color: AppColors.success,
            width: 12,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: data.expense,
            color: AppColors.error,
            width: 12,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }
}
