import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/widgets/empty/empty_state.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/utils/routes.dart';
import '../../domain/entities/expense.dart';
import '../blocs/expense/expense_bloc.dart';
import '../blocs/expense/expense_event.dart';
import '../blocs/expense/expense_state.dart';
import '../widgets/expense_card.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String _selectedFilter = 'All';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ExpenseBloc>()..add(const LoadExpenses()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Expenses'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterSheet,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchSheet,
            ),
          ],
        ),
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExpenseError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<ExpenseBloc>().add(const LoadExpenses()),
              );
            }

            if (state is ExpenseLoaded) {
              if (state.expenses.isEmpty) {
                return EmptyState(
                  title: 'No Expenses Yet',
                  subtitle: 'Start tracking your spending',
                  icon: Icons.receipt_long_outlined,
                  actionText: 'Add Expense',
                  onAction: () => context.push(AppRoutes.addTransaction),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ExpenseBloc>().add(const LoadExpenses());
                },
                child: Column(
                  children: [
                    // Summary Card
                    Container(
                      margin: EdgeInsets.all(DesignTokens.space16),
                      padding: EdgeInsets.all(DesignTokens.space16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.error, AppColors.error.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: DesignTokens.borderRadiusLg,
                        boxShadow: DesignTokens.coloredShadow(AppColors.error),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Spent',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: DesignTokens.textSm,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '\$${_calculateTotal(state.expenses).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: DesignTokens.text3xl,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${state.expenses.length} Transactions',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: DesignTokens.textSm,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _getDateRangeText(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: DesignTokens.textXs,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expense List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: DesignTokens.space16),
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          return ExpenseCard(
                            expense: state.expenses[index],
                            onTap: () => _showExpenseDetail(state.expenses[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await context.push(AppRoutes.addTransaction);
            if (result == true && mounted) {
              context.read<ExpenseBloc>().add(const LoadExpenses());
            }
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  String _getDateRangeText() {
    if (_startDate != null && _endDate != null) {
      return '${_startDate!.day}/${_startDate!.month} - ${_endDate!.day}/${_endDate!.month}';
    }
    return 'This Month';
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(DesignTokens.space20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Expenses',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space16),
            Wrap(
              spacing: 8,
              children: ['All', 'Today', 'This Month', 'Last Month', 'Custom']
                  .map((filter) => FilterChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() => _selectedFilter = filter);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: DesignTokens.space16,
          right: DesignTokens.space16,
          top: DesignTokens.space20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search expenses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
              onChanged: (value) {
                // Implement search
              },
            ),
            SizedBox(height: DesignTokens.space16),
          ],
        ),
      ),
    );
  }

  void _showExpenseDetail(Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(DesignTokens.space20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expense Details',
                    style: TextStyle(
                      fontSize: DesignTokens.textXl,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: DesignTokens.space24),
              Center(
                child: Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: DesignTokens.text4xl,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.space24),
              _buildDetailRow('Description', expense.description ?? 'N/A'),
              _buildDetailRow('Category', expense.categoryId),
              _buildDetailRow('Date', '${expense.date.day}/${expense.date.month}/${expense.date.year}'),
              if (expense.merchant != null) _buildDetailRow('Merchant', expense.merchant!),
              if (expense.note != null) _buildDetailRow('Note', expense.note!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.textSm,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: DesignTokens.textBase,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
