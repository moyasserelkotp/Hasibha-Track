import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedReportType = 'Spending Summary';

  final List<String> _reportTypes = [
    'Spending Summary',
    'Budget Performance',
    'Category Breakdown',
    'Monthly Comparison',
    'Savings Progress',
    'Debt Summary',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Report Type Selection
            Text(
              'Report Type',
              style: TextStyle(
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.space16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: DesignTokens.borderRadiusMd,
                boxShadow: DesignTokens.shadowSm,
              ),
              child: DropdownButton<String>(
                value: _selectedReportType,
                isExpanded: true,
                underline: const SizedBox(),
                items: _reportTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedReportType = value!);
                },
              ),
            ),

            SizedBox(height: DesignTokens.space24),

            // Date Range Selection
            Text(
              'Date Range',
              style: TextStyle(
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space12),
            Row(
              children: [
                Expanded(
                  child: _buildDateCard(
                    'From',
                    _startDate,
                    () => _selectDate(context, true),
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildDateCard(
                    'To',
                    _endDate,
                    () => _selectDate(context, false),
                  ),
                ),
              ],
            ),

            SizedBox(height: DesignTokens.space24),

            // Quick Date Ranges
            Text(
              'Quick Selection',
              style: TextStyle(
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickDateChip('This Month', () {
                  setState(() {
                    _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                    _endDate = DateTime.now();
                  });
                }),
                _buildQuickDateChip('Last Month', () {
                  final lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
                  setState(() {
                    _startDate = lastMonth;
                    _endDate = DateTime(lastMonth.year, lastMonth.month + 1, 0);
                  });
                }),
                _buildQuickDateChip('Last 3 Months', () {
                  setState(() {
                    _startDate = DateTime.now().subtract(const Duration(days: 90));
                    _endDate = DateTime.now();
                  });
                }),
                _buildQuickDateChip('This Year', () {
                  setState(() {
                    _startDate = DateTime(DateTime.now().year, 1, 1);
                    _endDate = DateTime.now();
                  });
                }),
              ],
            ),

            SizedBox(height: DesignTokens.space32),

            // Export Options
            Text(
              'Export Format',
              style: TextStyle(
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space12),
            Row(
              children: [
                Expanded(
                  child: _buildExportOption(
                    Icons.picture_as_pdf,
                    'PDF',
                    AppColors.error,
                    _exportAsPDF,
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildExportOption(
                    Icons.table_chart,
                    'CSV',
                    AppColors.success,
                    _exportAsCSV,
                  ),
                ),
              ],
            ),

            SizedBox(height: DesignTokens.space32),

            // Generate Button
            PrimaryButton(
              text: 'Generate Report',
              onPressed: _generateReport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(String label, DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(DesignTokens.space16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: DesignTokens.borderRadiusMd,
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.textSm,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDateChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: AppColors.primary),
    );
  }

  Widget _buildExportOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(DesignTokens.space20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: DesignTokens.borderRadiusMd,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40.sp),
            SizedBox(height: DesignTokens.space8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Generated'),
        content: Text(
          'Your $_selectedReportType report for ${_startDate.day}/${_startDate.month}/${_startDate.year} - ${_endDate.day}/${_endDate.month}/${_endDate.year} is ready.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportAsPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting as PDF...')),
    );
  }

  void _exportAsCSV() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting as CSV...')),
    );
  }
}
