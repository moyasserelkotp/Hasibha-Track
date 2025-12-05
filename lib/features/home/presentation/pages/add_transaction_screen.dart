import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/widgets/animations/animations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../cubit/add_transaction_cubit.dart';
import '../cubit/add_transaction_state.dart';

class AddTransactionScreen extends StatefulWidget {
  final String? type; // 'expense' or 'income'

  const AddTransactionScreen({super.key, this.type});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  late String _transactionType;

  // Predefined categories
  final List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Transportation', 'icon': Icons.directions_car},
    {'name': 'Entertainment', 'icon': Icons.movie},
    {'name': 'Shopping', 'icon': Icons.shopping_bag},
    {'name': 'Bills', 'icon': Icons.receipt_long},
    {'name': 'Health', 'icon': Icons.medical_services},
    {'name': 'Education', 'icon': Icons.school},
    {'name': 'Other', 'icon': Icons.more_horiz},
  ];

  final List<Map<String, dynamic>> _incomeCategories = [
    {'name': 'Salary', 'icon': Icons.account_balance_wallet},
    {'name': 'Freelance', 'icon': Icons.work},
    {'name': 'Investment', 'icon': Icons.trending_up},
    {'name': 'Gift', 'icon': Icons.card_giftcard},
    {'name': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    _transactionType = widget.type ?? 'expense';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentCategories =>
      _transactionType == 'expense' ? _expenseCategories : _incomeCategories;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        AppSnackBar.showError(context, message: AppStrings.errorSelectCategory);
        return;
      }

      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        AppSnackBar.showError(context, message: AppStrings.errorInvalidAmount);
        return;
      }

      context.read<AddTransactionCubit>().addTransaction(
            title: _titleController.text,
            amount: amount,
            category: _selectedCategory!,
            type: _transactionType,
            date: _selectedDate,
            description: _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<AddTransactionCubit>(
      create: (_) => di.sl<AddTransactionCubit>(),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 100.w,
          leading: TextButton.icon(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            label: Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          title: Text(
            AppStrings.addTransaction,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<AddTransactionCubit, AddTransactionState>(
          listener: (context, state) {
            if (state is AddTransactionSuccess) {
              AppSnackBar.showSuccess(context, message: AppStrings.transactionAdded);
              // Pop and indicate success to refresh home screen
              context.pop(true);
            } else if (state is AddTransactionError) {
              AppSnackBar.showError(context, message: state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Toggle
                    FadeSlideAnimation(
                      delay: Duration(milliseconds: 100),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                'expense',
                                AppStrings.expense,
                                AppColors.error,
                              ),
                            ),
                            Expanded(
                              child: _buildTypeButton(
                                'income',
                                AppStrings.income,
                                AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Title Field
                    FadeSlideAnimation(
                      delay: Duration(milliseconds: 200),
                      child: _buildTextField(
                        controller: _titleController,
                        label: AppStrings.title,
                        hint: AppStrings.enterTitle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.errorEnterTitle;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Amount Field
                    FadeSlideAnimation(
                      delay: Duration(milliseconds: 300),
                      child: _buildTextField(
                        controller: _amountController,
                        label: AppStrings.amount,
                        hint: AppStrings.enterAmount,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        prefix: Text('\$ ', style: TextStyle(fontSize: 16.sp)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.errorRequiredField;
                          }
                          if (double.tryParse(value) == null) {
                            return AppStrings.errorInvalidAmount;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Category Selection
                    FadeSlideAnimation(
                      delay: Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.category,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: _currentCategories.map((category) {
                              final isSelected = _selectedCategory == category['name'];
                              return _buildCategoryChip(
                                category['name'],
                                category['icon'],
                                isSelected,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Date Picker
                    FadeSlideAnimation(
                      delay: Duration(milliseconds: 500),
                      child: InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.date,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.calendar_today, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Description Field (Optional)
                    FadeSlideAnimation(
                      delay: Duration(milliseconds: 600),
                      child: _buildTextField(
                        controller: _descriptionController,
                        label: AppStrings.description,
                        hint: AppStrings.enterDescription,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Submit Button
                    FadeSlideAnimation(
                      delay: Duration(milliseconds: 700),
                      child: PrimaryButton(
                        text: AppStrings.save,
                        onPressed: state is AddTransactionLoading ? null : _submit,
                        isLoading: state is AddTransactionLoading,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, String label, Color color) {
    final isSelected = _transactionType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _transactionType = type;
          _selectedCategory = null; // Reset category when switching type
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.white : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String name, IconData icon, bool isSelected) {
    final color = _transactionType == 'expense' ? AppColors.error : AppColors.success;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = name;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withAlpha((255 * 0.1).round())
              : (isDark ? AppColors.surfaceDark : AppColors.surface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected ? color : AppColors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    Widget? prefix,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix != null ? Padding(
              padding: EdgeInsets.only(left: 16.w, top: 12.h),
              child: prefix,
            ) : null,
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
