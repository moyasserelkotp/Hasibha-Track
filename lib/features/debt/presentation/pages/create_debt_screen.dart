import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_enums.dart';
import '../blocs/debt_bloc.dart';
import '../blocs/debt_event.dart';

class CreateDebtScreen extends StatefulWidget {
  final Debt? debt; // For editing

  const CreateDebtScreen({super.key, this.debt});

  @override
  State<CreateDebtScreen> createState() => _CreateDebtScreenState();
}

class _CreateDebtScreenState extends State<CreateDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _interestRateController = TextEditingController();

  DebtType _selectedType = DebtType.OWED_BY_ME;
  DateTime? _dueDate;
  PaymentFrequency? _paymentFrequency;

  @override
  void initState() {
    super.initState();
    if (widget.debt != null) {
      _titleController.text = widget.debt!.title;
      _descriptionController.text = widget.debt!.description;
      _amountController.text = widget.debt!.amount.toString();
      _contactNameController.text = widget.debt!.contactName ?? '';
      _contactPhoneController.text = widget.debt!.contactPhone ?? '';
      _interestRateController.text = widget.debt!.interestRate?.toString() ?? '';
      _selectedType = widget.debt!.type;
      _dueDate = widget.debt!.dueDate;
      _paymentFrequency = widget.debt!.paymentFrequency;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.debt != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Debt' : 'Create Debt'),
        backgroundColor: AppColors.primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Debt Type Selector
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
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
                    'Debt Type',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          DebtType.OWED_BY_ME,
                          'I Owe',
                          Icons.arrow_upward,
                          AppColors.error,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildTypeOption(
                          DebtType.OWED_TO_ME,
                          'Owed To Me',
                          Icons.arrow_downward,
                          AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Loan from John',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: '0.00',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Contact Name
            TextFormField(
              controller: _contactNameController,
              decoration: InputDecoration(
                labelText: 'Contact Name (Optional)',
                hintText: 'Person or organization',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Contact Phone
            TextFormField(
              controller: _contactPhoneController,
              decoration: InputDecoration(
                labelText: 'Contact Phone (Optional)',
                hintText: '+1 234 567 8900',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.h),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Add notes or details',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.h),

            // Due Date
            InkWell(
              onTap: _selectDueDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Due Date (Optional)',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  _dueDate != null
                      ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                      : 'Select due date',
                  style: TextStyle(
                    color: _dueDate != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Interest Rate (Optional)
            TextFormField(
              controller: _interestRateController,
              decoration: InputDecoration(
                labelText: 'Interest Rate % (Optional)',
                hintText: '0.0',
                prefixIcon: const Icon(Icons.percent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),

            // Payment Frequency
            DropdownButtonFormField<PaymentFrequency>(
              value: _paymentFrequency,
              decoration: InputDecoration(
                labelText: 'Payment Frequency (Optional)',
                prefixIcon: const Icon(Icons.repeat),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ...PaymentFrequency.values.map((freq) {
                  return DropdownMenuItem(
                    value: freq,
                    child: Text(freq.displayName),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _paymentFrequency = value;
                });
              },
            ),
            SizedBox(height: 24.h),

            // Submit Button
            PrimaryButton(
              onPressed: _submitForm,
              text: isEdit ? 'Update Debt' : 'Create Debt',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(
    DebtType type,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(51) : AppColors.grey.withAlpha(51),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textSecondary),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final debt = Debt(
        id: widget.debt?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        paidAmount: widget.debt?.paidAmount ?? 0.0,
        type: _selectedType,
        contactName: _contactNameController.text.trim().isEmpty
            ? null
            : _contactNameController.text.trim(),
        contactPhone: _contactPhoneController.text.trim().isEmpty
            ? null
            : _contactPhoneController.text.trim(),
        createdDate: widget.debt?.createdDate ?? DateTime.now(),
        dueDate: _dueDate,
        status: widget.debt?.status ?? DebtStatus.ACTIVE,
        interestRate: _interestRateController.text.isEmpty
            ? null
            : double.tryParse(_interestRateController.text),
        paymentFrequency: _paymentFrequency,
        payments: widget.debt?.payments ?? [],
      );

      if (widget.debt != null) {
        context.read<DebtBloc>().add(UpdateDebt(debt));
      } else {
        context.read<DebtBloc>().add(CreateDebt(debt));
      }

      context.pop();
    }
  }
}
