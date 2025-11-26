import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../domain/entities/budget.dart';
import '../blocs/budget/budget_bloc.dart';
import '../blocs/budget/budget_event.dart';
import '../blocs/budget/budget_state.dart';
import '../../../expense/presentation/blocs/category/category_bloc.dart';
import '../../../expense/presentation/blocs/category/category_event.dart';
import '../../../expense/presentation/blocs/category/category_state.dart';
import '../widgets/period_picker.dart';

class CreateBudgetScreen extends StatefulWidget {
  final String? budgetId;

  const CreateBudgetScreen({super.key, this.budgetId});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();

  String? _selectedCategoryId;
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _alertsEnabled = true;
  double _alertThreshold = 80.0;

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _calculateEndDate() {
    switch (_selectedPeriod) {
      case BudgetPeriod.daily:
        _endDate = _startDate.add(const Duration(days: 1));
        break;
      case BudgetPeriod.weekly:
        _endDate = _startDate.add(const Duration(days: 7));
        break;
      case BudgetPeriod.monthly:
        _endDate = DateTime(_startDate.year, _startDate.month + 1, _startDate.day);
        break;
      case BudgetPeriod.yearly:
        _endDate = DateTime(_startDate.year + 1, _startDate.month, _startDate.day);
        break;
      case BudgetPeriod.custom:
        // Keep current end date
        break;
    }
  }

  void _submitBudget() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      AppSnackBar.showError(context, message: 'Please select a category');
      return;
    }

    final budget = Budget(
      id: widget.budgetId ?? const Uuid().v4(),
      categoryId: _selectedCategoryId!,
      limit: double.parse(_limitController.text),
      period: _selectedPeriod,
      spent: 0.0,
      startDate: _startDate,
      endDate: _endDate,
      isActive: true,
      alertSettings: AlertSettings(
        enabled: _alertsEnabled,
        threshold: _alertThreshold,
        notifyOnExceed: true,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.budgetId == null) {
      context.read<BudgetBloc>().add(CreateBudget(budget));
    } else {
      context.read<BudgetBloc>().add(UpdateBudget(budget));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<BudgetBloc>()),
        BlocProvider(create: (_) => di.sl<CategoryBloc>()..add(const LoadCategories())),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(widget.budgetId == null ? 'Create Budget' : 'Edit Budget'),
          backgroundColor: AppColors.primary,
        ),
        body: BlocListener<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetOperationSuccess) {
              AppSnackBar.showSuccess(context, message: state.message);
              context.pop();
            } else if (state is BudgetError) {
              AppSnackBar.showError(context, message: state.message);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category Selection
                  Text(
                    'Category *',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded) {
                        return Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: state.categories.where((c) => c.type == 'expense').map((category) {
                            final isSelected = _selectedCategoryId == category.id;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedCategoryId = category.id);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Budget Limit
                  TextFormField(
                    controller: _limitController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Budget Limit *',
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter budget limit';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Period Picker
                  PeriodPicker(
                    selectedPeriod: _selectedPeriod,
                    onPeriodSelected: (period) {
                      setState(() {
                        _selectedPeriod = period;
                        _calculateEndDate();
                      });
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Date Range
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'Start Date',
                          date: _startDate,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              setState(() {
                                _startDate = date;
                                _calculateEndDate();
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildDateField(
                          label: 'End Date',
                          date: _endDate,
                          onTap: _selectedPeriod == BudgetPeriod.custom
                              ? () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _endDate,
                                    firstDate: _startDate,
                                    lastDate: DateTime(2030),
                                  );
                                  if (date != null) {
                                    setState(() => _endDate = date);
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Alert Settings
                  Text(
                    'Alert Settings',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SwitchListTile(
                    value: _alertsEnabled,
                    onChanged: (value) {
                      setState(() => _alertsEnabled = value);
                    },
                    title: const Text('Enable Alerts'),
                    subtitle: const Text('Get notified when approaching limit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_alertsEnabled) ...[
                    Text(
                      'Alert at ${_alertThreshold.toInt()}% of budget',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Slider(
                      value: _alertThreshold,
                      min: 50,
                      max: 100,
                      divisions: 10,
                      label: '${_alertThreshold.toInt()}%',
                      onChanged: (value) {
                        setState(() => _alertThreshold = value);
                      },
                    ),
                  ],

                  SizedBox(height: 32.h),

                  // Submit Button
                  BlocBuilder<BudgetBloc, BudgetState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        text: widget.budgetId == null ? 'Create Budget' : 'Update Budget',
                        isLoading: state is BudgetLoading,
                        onPressed: _submitBudget,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: onTap == null ? AppColors.grey : AppColors.border),
          borderRadius: BorderRadius.circular(12.r),
          color: onTap == null ? AppColors.grey.withValues(alpha: 0.1) : null,
        ),
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
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
