import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../domain/entities/savings_goal.dart';
import '../blocs/savings_bloc.dart';
import '../blocs/savings_event.dart';
import '../blocs/savings_state.dart';

class CreateSavingsGoalScreen extends StatefulWidget {
  const CreateSavingsGoalScreen({super.key});

  @override
  State<CreateSavingsGoalScreen> createState() => _CreateSavingsGoalScreenState();
}

class _CreateSavingsGoalScreenState extends State<CreateSavingsGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  
  DateTime? _deadline;
  String _selectedIcon = 'savings';
  Color _selectedColor = AppColors.primary;

  final List<Map<String, dynamic>> _icons = [
    {'id': 'savings', 'icon': Icons.savings, 'label': 'General'},
    {'id': 'car', 'icon': Icons.directions_car, 'label': 'Car'},
    {'id': 'house', 'icon': Icons.home, 'label': 'House'},
    {'id': 'vacation', 'icon': Icons.flight, 'label': 'Trip'},
    {'id': 'emergency', 'icon': Icons.medical_services, 'label': 'Emergency'},
    {'id': 'gadget', 'icon': Icons.devices, 'label': 'Gadget'},
  ];

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final goal = SavingsGoal(
      id: const Uuid().v4(),
      name: _nameController.text,
      targetAmount: double.parse(_amountController.text),
      currentAmount: 0,
      deadline: _deadline,
      icon: _selectedIcon,
      color: _selectedColor.value,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<SavingsBloc>().add(CreateSavingsGoal(goal));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SavingsBloc>(
      create: (_) => di.sl<SavingsBloc>(),
      child: BlocListener<SavingsBloc, SavingsState>(
        listener: (context, state) {
          if (state is SavingsOperationSuccess) {
            context.pop();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Create Goal'),
            backgroundColor: AppColors.primary,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Goal Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  SizedBox(height: 16.h),

                  // Target Amount
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Target Amount',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (v) {
                      if (v?.isEmpty == true) return 'Required';
                      if (double.tryParse(v!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Icon Selection
                  Text('Select Icon', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 16.w,
                    runSpacing: 16.h,
                    children: _icons.map((item) {
                      final isSelected = _selectedIcon == item['id'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIcon = item['id']),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            item['icon'],
                            color: isSelected ? AppColors.primary : Colors.grey,
                            size: 24.sp,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Color Picker
                  Text('Select Color', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (color) {
                                setState(() => _selectedColor = color);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Deadline
                  ListTile(
                    title: const Text('Target Date (Optional)'),
                    subtitle: Text(_deadline == null 
                      ? 'No deadline set' 
                      : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) setState(() => _deadline = date);
                    },
                  ),
                  SizedBox(height: 32.h),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () => _submit(), // Call submit on the state
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text('Create Goal'),
                        );
                      }
                    ),
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
