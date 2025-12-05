import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/utils/routes.dart';
import '../blocs/debt_bloc.dart';
import '../blocs/debt_event.dart';
import '../blocs/debt_state.dart';
import '../widgets/debt_card.dart';
import '../widgets/debt_summary_card.dart';

class DebtDashboardScreen extends StatelessWidget {
  const DebtDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DebtBloc>(
      create: (_) => di.sl<DebtBloc>()..add(const LoadDebts()),
      child: const _DebtDashboardContent(),
    );
  }
}

class _DebtDashboardContent extends StatefulWidget {
  const _DebtDashboardContent();

  @override
  State<_DebtDashboardContent> createState() => _DebtDashboardContentState();
}

class _DebtDashboardContentState extends State<_DebtDashboardContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Debt Tracking'),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Owed To Me'),
            Tab(text: 'Owed By Me'),
          ],
        ),
      ),
      body: BlocConsumer<DebtBloc, DebtState>(
        listener: (context, state) {
          if (state is DebtOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DebtError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DebtLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DebtLoaded) {
            return Column(
              children: [
                // Summary Card
                DebtSummaryCard(
                  totalOwedToMe: state.totalOwedToMe,
                  totalOwedByMe: state.totalOwedByMe,
                  netBalance: state.netBalance,
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDebtList(state.debts),
                      _buildDebtList(state.receivables),
                      _buildDebtList(state.payables),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(
            child: Text(
              'No debts to display',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createDebt),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDebtList(List debts) {
    if (debts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined,
                size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            Text(
              'No debts found',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DebtBloc>().add(const RefreshDebts());
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: debts.length,
        itemBuilder: (context, index) {
          return DebtCard(
            debt: debts[index],
            onTap: () {
              // Navigate to debt detail
              context.push('${AppRoutes.debts}/${debts[index].id}');
            },
          );
        },
      ),
    );
  }
}
