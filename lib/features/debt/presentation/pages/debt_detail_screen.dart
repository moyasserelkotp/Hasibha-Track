import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/routes.dart';
import '../../../../shared/const/colors.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_enums.dart';
import '../blocs/debt_bloc.dart';
import '../blocs/debt_event.dart';
import '../widgets/add_payment_dialog.dart';
import '../widgets/payment_item.dart';

class DebtDetailScreen extends StatelessWidget {
  final Debt debt;

  const DebtDetailScreen({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final isReceivable = debt.type.isReceivable;
    final primaryColor = isReceivable ? AppColors.success : AppColors.error;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Debt Details'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit screen
              context.push(AppRoutes.createDebt, extra: debt);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Header Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withAlpha(179)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withAlpha(76),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isReceivable ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      debt.type.displayName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withAlpha(229),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  debt.title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (debt.contactName != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    debt.contactName!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withAlpha(204),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                        Text(
                          '\$${debt.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Remaining',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                        Text(
                          '\$${debt.remainingAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                LinearProgressIndicator(
                  value: (debt.progressPercentage / 100).clamp(0.0, 1.0),
                  backgroundColor: Colors.white.withAlpha(76),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8.h,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${debt.progressPercentage.toStringAsFixed(1)}% paid',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Details Section
          _buildSection(
            'Details',
            [
              if (debt.description.isNotEmpty)
                _buildDetailRow(Icons.notes, 'Description', debt.description),
              if (debt.dueDate != null)
                _buildDetailRow(
                  Icons.calendar_today,
                  'Due Date',
                  '${debt.dueDate!.day}/${debt.dueDate!.month}/${debt.dueDate!.year}',
                ),
              if (debt.contactPhone != null)
                _buildDetailRow(Icons.phone, 'Phone', debt.contactPhone!),
              if (debt.interestRate != null)
                _buildDetailRow(
                  Icons.percent,
                  'Interest Rate',
                  '${debt.interestRate}%',
                ),
              if (debt.paymentFrequency != null)
                _buildDetailRow(
                  Icons.repeat,
                  'Payment Frequency',
                  debt.paymentFrequency!.displayName,
                ),
              _buildDetailRow(
                Icons.info,
                'Status',
                debt.status.displayName,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Payments Section
          _buildSection(
            'Payment History (${debt.payments.length})',
            debt.payments.isEmpty
                ? [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          'No payments yet',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ]
                : debt.payments
                    .map((payment) => PaymentItem(payment: payment))
                    .toList(),
          ),
        ],
      ),
      floatingActionButton: debt.status != DebtStatus.PAID
          ? FloatingActionButton.extended(
              onPressed: () => _showAddPaymentDialog(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add),
              label: const Text('Add Payment'),
            )
          : null,
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: AppColors.textSecondary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<DebtBloc>(),
        child: AddPaymentDialog(debt: debt),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Debt'),
        content: const Text('Are you sure you want to delete this debt?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DebtBloc>().add(DeleteDebt(debt.id));
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
