import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/spending_analytics.dart';
import '../../../../shared/const/colors.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<String, double> categoryBreakdown;

  const CategoryPieChart({
    super.key,
    required this.categoryBreakdown,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryBreakdown.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final total = widget.categoryBreakdown.values.fold(0.0, (sum, item) => sum + item);
    final sortedEntries = widget.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort descending

    // Limit to top 5 and group others
    final topEntries = sortedEntries.take(5).toList();
    // In a real app, we'd group the rest into "Other", but for simplicity we'll just show top 5

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: List.generate(topEntries.length, (i) {
                  final isTouched = i == touchedIndex;
                  final fontSize = isTouched ? 16.0 : 12.0;
                  final radius = isTouched ? 60.0 : 50.0;
                  final entry = topEntries[i];
                  final percentage = (entry.value / total) * 100;
                  
                  // Generate color based on index
                  final color = _getColor(i);

                  return PieChartSectionData(
                    color: color,
                    value: entry.value,
                    title: '${percentage.toInt()}%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(topEntries.length, (i) {
              final entry = topEntries[i];
              // We need to fetch category name from ID, but for now we'll use ID or a placeholder
              // In a real app, we'd pass a map of ID -> Name or use a Category object
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getColor(i),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        // Ideally this should be the category name
                        // We'll assume the key is the name for now or handle it in the parent
                        entry.key, 
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Color _getColor(int index) {
    const colors = [
      Color(0xFF4CAF50), // Green
      Color(0xFF2196F3), // Blue
      Color(0xFFE91E63), // Pink
      Color(0xFFFF9800), // Orange
      Color(0xFF9C27B0), // Purple
      Color(0xFF00BCD4), // Cyan
    ];
    return colors[index % colors.length];
  }
}
