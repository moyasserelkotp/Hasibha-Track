import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';

class MonthlyComparisonChart extends StatelessWidget {
  const MonthlyComparisonChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for current vs last month
    final List<Map<String, dynamic>> data = [
      {'category': 'Food', 'current': 450, 'last': 380},
      {'category': 'Transport', 'current': 280, 'last': 320},
      {'category': 'Shopping', 'current': 320, 'last': 250},
      {'category': 'Bills', 'current': 500, 'last': 500},
      {'category': 'Other', 'current': 180, 'last': 210},
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 600,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final category = data[groupIndex]['category'];
              final value = rod.toY;
              final label = rodIndex == 0 ? 'This Month' : 'Last Month';
              
              return BarTooltipItem(
                '$category\n$label\n\$${value.toInt()}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < 0 || value.toInt() >= data.length) {
                  return const Text('');
                }
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    data[value.toInt()]['category'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: 150,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item['current'].toDouble(),
                color: const Color(0xFF00BFA5),
                width: 14.w,
                borderRadius: BorderRadius.circular(4.r),
              ),
              BarChartRodData(
                toY: item['last'].toDouble(),
                color: const Color(0xFF00BFA5).withValues(alpha: 0.3),
                width: 14.w,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
            barsSpace: 4.w,
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 150,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.border.withValues(alpha: 0.3),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}
