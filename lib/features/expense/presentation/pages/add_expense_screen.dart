import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../domain/entities/expense.dart';
import '../blocs/expense/expense_bloc.dart';
import '../blocs/expense/expense_event.dart';
import '../blocs/expense/expense_state.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';
import '../widgets/category_picker.dart';
import '../widgets/multi_format_entry_buttons.dart';

class AddExpenseScreen extends StatefulWidget {
  final String? expenseId;
  final String? initialImagePath;

  const AddExpenseScreen({
    super.key, 
    this.expenseId,
    this.initialImagePath,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  final _merchantController = TextEditingController();
  
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  final List<String> _tags = [];
  bool _isRecurring = false;
  String? _receiptImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      // Defer the event to ensure context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ExpenseBloc>().add(
          ImportExpenseFromImage(widget.initialImagePath!),
        );
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  void _handleOcrResult(Expense expense) {
    setState(() {
      _amountController.text = expense.amount.toString();
      _descriptionController.text = expense.description ?? '';
      _merchantController.text = expense.merchant ?? '';
      _selectedDate = expense.date;
      _receiptImagePath = expense.receiptImagePath;
      if (expense.categoryId.isNotEmpty) {
        _selectedCategoryId = expense.categoryId;
      }
    });
  }

  void _submitExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      AppSnackBar.showError(context, message: 'Please select a category');
      return;
    }

    final expense = Expense(
      id: widget.expenseId ?? const Uuid().v4(),
      amount: double.parse(_amountController.text),
      categoryId: _selectedCategoryId!,
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      merchant: _merchantController.text.trim().isEmpty ? null : _merchantController.text.trim(),
      tags: _tags.isEmpty ? null : _tags,
      receiptImagePath: _receiptImagePath,
      isRecurring: _isRecurring,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.expenseId == null) {
      context.read<ExpenseBloc>().add(CreateExpense(expense));
    } else {
      context.read<ExpenseBloc>().add(UpdateExpense(expense));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ExpenseBloc>()),
        BlocProvider(create: (_) => di.sl<CategoryBloc>()..add(const LoadCategories())),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(widget.expenseId == null ? 'Add Expense' : 'Edit Expense'),
          backgroundColor: AppColors.primary,
        ),
        body: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseOperationSuccess) {
              AppSnackBar.showSuccess(context, message: state.message);
              context.pop();
            } else if (state is ExpenseError) {
              AppSnackBar.showError(context, message: state.message);
            } else if (state is ExpenseImported) {
              _handleOcrResult(state.expense);
              AppSnackBar.showSuccess(context, message: 'Receipt scanned successfully!');
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Multi-format Entry Buttons
                  MultiFormatEntryButtons(
                    onImageSelected: (imagePath) {
                      context.read<ExpenseBloc>().add(
                        ImportExpenseFromImage(imagePath),
                      );
                    },
                    onVoiceRecorded: (text) {
                      // Parse voice input - simple implementation
                      _descriptionController.text = text;
                    },
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount *',
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
                        return 'Please enter amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Category Picker
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded) {
                        return CategoryPicker(
                          categories: state.categories,
                          selectedCategoryId: _selectedCategoryId,
                          onCategorySelected: (categoryId) {
                            setState(() => _selectedCategoryId = categoryId);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description *',
                      hintText: 'What did you buy?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Merchant
                  TextFormField(
                    controller: _merchantController,
                    decoration: InputDecoration(
                      labelText: 'Merchant (Optional)',
                      hintText: 'Where did you buy it?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Date Picker
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.primary),
                          SizedBox(width: 12.w),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Note
                  TextFormField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Note (Optional)',
                      hintText: 'Add any additional details',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Recurring Checkbox
                  CheckboxListTile(
                    value: _isRecurring,
                    onChanged: (value) {
                      setState(() => _isRecurring = value ?? false);
                    },
                    title: const Text('Recurring Expense'),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Submit Button
                  BlocBuilder<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        text: widget.expenseId == null ? 'Add Expense' : 'Update Expense',
                        isLoading: state is ExpenseLoading,
                        onPressed: _submitExpense,
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
}
