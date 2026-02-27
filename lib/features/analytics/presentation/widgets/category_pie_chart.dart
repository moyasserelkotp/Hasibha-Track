import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<String, double> categoryData;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return AppColors.foodColor;
      case 'transport':
      case 'transportation':
        return AppColors.transportColor;
      case 'shopping':
        return AppColors.shoppingColor;
      case 'entertainment':
        return AppColors.entertainmentColor;
      case 'bills':
      case 'utilities':
        return AppColors.billsColor;
      case 'health':
      case 'medical':
        return AppColors.healthColor;
      case 'education':
        return const Color(0xFF6495ED);
      case 'travel':
        return const Color(0xFFFF9800);
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
      case 'transportation':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'bills':
      case 'utilities':
        return Icons.receipt_long_rounded;
      case 'health':
      case 'medical':
        return Icons.local_hospital_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'travel':
        return Icons.flight_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryData.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pie_chart_outline_rounded, size: 48.sp, color: AppColors.textSecondary.withValues(alpha: 0.3)),
              SizedBox(height: 12.h),
              Text(
                'No category data available',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final total = widget.categoryData.values.fold<double>(0, (sum, val) => sum + val);
    final categories = widget.categoryData.entries.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 240.h,
          child: Stack(
            children: [
              PieChart(
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
                  sectionsSpace: 4,
                  centerSpaceRadius: 60.r,
                  sections: List.generate(categories.length, (i) {
                    final isTouched = i == touchedIndex;
                    final categoryEntry = categories[i];
                    final color = _getCategoryColor(categoryEntry.key);
                    final percentage = (categoryEntry.value / total * 100);

                    return PieChartSectionData(
                      color: color,
                      value: categoryEntry.value,
                      title: '${percentage.toStringAsFixed(0)}%',
                      radius: isTouched ? 45.r : 38.r,
                      titleStyle: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      badgeWidget: isTouched
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: color,
                                  width: 2.w,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getCategoryIcon(categoryEntry.key),
                                    size: 14.sp,
                                    color: color,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '\$${categoryEntry.value.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null,
                      badgePositionPercentageOffset: 1.3,
                    );
                  }),
                ),
                swapAnimationDuration: const Duration(milliseconds: 600),
                swapAnimationCurve: Curves.easeInOutCubic,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '\$${total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: const Color(0xFF1A1C1E),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DesignTokens.space24),
        // Legend with better styling
        Wrap(
          spacing: 8.w,
          runSpacing: 10.h,
          alignment: WrapAlignment.center,
          children: categories.asMap().entries.map((entry) {
            final index = entry.key;
            final categoryName = entry.value.key;
            final categoryValue = entry.value.value;
            final isSelected = index == touchedIndex;
            final percentage = (categoryValue / total * 100);
            final color = _getCategoryColor(categoryName);

            return GestureDetector(
              onTap: () {
                setState(() {
                  touchedIndex = touchedIndex == index ? -1 : index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.1)
                      : AppColors.surface,
                  border: Border.all(
                    color: color.withValues(alpha: isSelected ? 1 : 0.3),
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(categoryName),
                      size: 14.sp,
                      color: color,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: color,
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
