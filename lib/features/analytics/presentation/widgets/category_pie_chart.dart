import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({super.key});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  // Mock data - would come from BLoC
  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'value': 450.0, 'color': const Color(0xFFFF6B6B)},
    {'name': 'Transport', 'value': 280.0, 'color': const Color(0xFF4ECDC4)},
    {'name': 'Shopping', 'value': 320.0, 'color': const Color(0xFFFFE66D)},
    {'name': 'Entertainment', 'value': 180.0, 'color': const Color(0xFF95E1D3)},
    {'name': 'Bills', 'value': 500.0, 'color': const Color(0xFFF38181)},
  ];

  @override
  Widget build(BuildContext context) {
    final total = categories.fold<double>(0, (sum, cat) => sum + cat['value']);

    return Column(
      children: [
        Expanded(
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
              centerSpaceRadius: 60.w,
              sections: List.generate(categories.length, (i) {
                final isTouched = i == touchedIndex;
                final fontSize = isTouched ? 16.0 : 12.0;
                final radius = isTouched ? 100.0 : 90.0;
                final category = categories[i];
                final percentage = (category['value'] / total * 100);

                return PieChartSectionData(
                  color: category['color'],
                  value: category['value'],
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: radius.w,
                  titleStyle: TextStyle(
                    fontSize: fontSize.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  badgeWidget: isTouched
                      ? Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: DesignTokens.shadowMd,
                          ),
                          child: Text(
                            '\$${category['value'].toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: category['color'],
                            ),
                          ),
                        )
                      : null,
                  badgePositionPercentageOffset: 1.3,
                );
              }),
            ),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          ),
        ),
        SizedBox(height: DesignTokens.space16),
        Wrap(
          spacing: 12.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.center,
          children: categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final isSelected = index == touchedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  touchedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category['color'].withValues(alpha: 0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: category['color'],
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: category['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: DesignTokens.textSm,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
