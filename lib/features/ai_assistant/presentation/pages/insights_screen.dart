import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/services/ai/mock_ai_service.dart';
import '../../../../di/injection.dart' as di;

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final _aiService = di.sl<MockAiService>();
  List<String> _insights = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateInsights();
  }

  Future<void> _generateInsights() async {
    setState(() {
      _isLoading = true;
    });

    // Mock user spending data
    final insights = await _aiService.generateInsights(
      totalExpenses: 1800,
      totalIncome: 3000,
      categorySpending: {
        'food': 450,
        'transport': 280,
        'shopping': 320,
        'entertainment': 180,
        'bills': 570,
      },
    );

    setState(() {
      _insights = insights;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Insights'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateInsights,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _generateInsights,
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.white, size: 48.sp),
                        SizedBox(height: 12.h),
                        Text(
                          'Your Financial Insights',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'AI-powered recommendations',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Insights list
                  ..._insights.map((insight) => _buildInsightCard(insight)),
                ],
              ),
            ),
    );
  }

  Widget _buildInsightCard(String insight) {
    final icon = _getIconForInsight(insight);
    final color = _getColorForInsight(insight);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              insight,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForInsight(String insight) {
    if (insight.contains('🎉')) return Icons.celebration;
    if (insight.contains('💡')) return Icons.lightbulb_outline;
    if (insight.contains('⚠️')) return Icons.warning_amber;
    if (insight.contains('🚨')) return Icons.error_outline;
    if (insight.contains('💰')) return Icons.attach_money;
    if (insight.contains('📊')) return Icons.bar_chart;
    if (insight.contains('🍽️')) return Icons.restaurant;
    return Icons.info_outline;
  }

  Color _getColorForInsight(String insight) {
    if (insight.contains('🎉')) return AppColors.success;
    if (insight.contains('⚠️') || insight.contains('🚨')) return AppColors.error;
    if (insight.contains('💡') || insight.contains('💰')) return AppColors.warning;
    return AppColors.info;
  }
}
