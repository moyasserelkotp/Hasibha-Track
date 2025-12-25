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

  // Mock data - using new AppColors for consistency
  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'value': 450.0, 'color': AppColors.foodColor, 'icon': Icons.restaurant_rounded},
    {'name': 'Transport', 'value': 280.0, 'color': AppColors.transportColor, 'icon': Icons.directions_car_rounded},
    {'name': 'Shopping', 'value': 320.0, 'color': AppColors.shoppingColor, 'icon': Icons.shopping_bag_rounded},
    {'name': 'Entertainment', 'value': 180.0, 'color': AppColors.entertainmentColor, 'icon': Icons.movie_rounded},
    {'name': 'Bills', 'value': 500.0, 'color': AppColors.billsColor, 'icon': Icons.receipt_long_rounded},
    {'name': 'Health', 'value': 150.0, 'color': AppColors.healthColor, 'icon': Icons.local_hospital_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final total = categories.fold<double>(0, (sum, cat) => sum + cat['value']);

    return Column(
      children: [
        // Chart Section with Center Text using Stack
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The Donut Chart
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
                  sectionsSpace: 2,
                  centerSpaceRadius: 50.r, // Slightly reduced to prevent overflow
                  sections: List.generate(categories.length, (i) {
                    final isTouched = i == touchedIndex;
                    final fontSize = isTouched ? 16.0 : 14.0;
                    final radius = isTouched ? 60.0 : 50.0; // Reduced radius
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
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      badgeWidget: isTouched
                          ? _buildBadge(category)
                          : null,
                      badgePositionPercentageOffset: 1.3,
                    );
                  }),
                ),
                swapAnimationDuration: const Duration(milliseconds: 600),
                swapAnimationCurve: Curves.easeInOutCubic,
              ),

              // Center Text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                    'Total',
                    style: TextStyle(
                      fontSize: DesignTokens.textSm,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: DesignTokens.text2xl,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 50.h), // Further increased spacing as requested
        
        // Legend with better styling
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          alignment: WrapAlignment.center,
          children: categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final isSelected = index == touchedIndex;
            final percentage = (category['value'] / total * 100);

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
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category['color'].withValues(alpha: 0.15)
                      : AppColors.surface,
                  border: Border.all(
                    color: category['color'],
                    width: isSelected ? 2 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: category['color'].withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'],
                      size: 16.sp,
                      color: category['color'],
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: DesignTokens.textSm,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: DesignTokens.textXs,
                        fontWeight: FontWeight.w600,
                        color: category['color'],
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

  Widget _buildBadge(Map<String, dynamic> category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: DesignTokens.shadowLg,
        border: Border.all(
          color: category['color'],
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category['icon'],
            size: 16.sp,
            color: category['color'],
          ),
          SizedBox(width: 4.w),
          Text(
            '\$${category['value'].toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: category['color'],
            ),
          ),
        ],
      ),
    );
  }
}
