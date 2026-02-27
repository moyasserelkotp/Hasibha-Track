import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/data/mock_data_provider.dart';
import '../../../../shared/utils/routes.dart';

class SharedBudgetsScreen extends StatefulWidget {
  const SharedBudgetsScreen({super.key});

  @override
  State<SharedBudgetsScreen> createState() => _SharedBudgetsScreenState();
}

class _SharedBudgetsScreenState extends State<SharedBudgetsScreen> {
  late List<Map<String, dynamic>> _sharedBudgets;

  @override
  void initState() {
    super.initState();
    _sharedBudgets = MockDataProvider.getMockSharedBudgets();
  }

  @override
  Widget build(BuildContext context) {
    final hasSharedBudgets = _sharedBudgets.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Shared Budgets'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () {
              _showJoinBudgetDialog(context);
            },
          ),
        ],
      ),
      body: hasSharedBudgets ? _buildBudgetsList() : _buildEmptyState(context),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'shared_budgets_fab',
        onPressed: () {
          _showCreateBudgetSheet(context);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Shared Budget', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 120.sp,
              color: AppColors.textHint,
            ),
            SizedBox(height: DesignTokens.space24),
            Text(
              'Collaborative Budgeting',
              style: TextStyle(
                fontSize: DesignTokens.text2xl,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.space12),
            Text(
              'Create shared budgets with family, roommates, or friends to manage expenses together.',
              style: TextStyle(
                fontSize: DesignTokens.textBase,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.space32),
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    Icons.people,
                    'Invite Members',
                    'Add family & friends',
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildFeatureCard(
                    Icons.receipt_long,
                    'Split Expenses',
                    'Track shared costs',
                  ),
                ),
              ],
            ),
            SizedBox(height: DesignTokens.space12),
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    Icons.sync,
                    'Real-time Sync',
                    'See updates instantly',
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildFeatureCard(
                    Icons.security,
                    'Role-based Access',
                    'Control permissions',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.borderRadiusMd,
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 32.sp),
          SizedBox(height: DesignTokens.space8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: DesignTokens.textSm,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: DesignTokens.textXs,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetsList() {
    return ListView.builder(
      padding: EdgeInsets.all(DesignTokens.space16),
      itemCount: _sharedBudgets.length,
      itemBuilder: (context, index) {
        final budget = _sharedBudgets[index];
        final progress = (budget['totalSpent'] as double) / (budget['totalBudget'] as double);
        final members = budget['members'] as List<dynamic>;
        
        return Container(
          margin: EdgeInsets.only(bottom: DesignTokens.space16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: DesignTokens.borderRadiusLg,
            boxShadow: DesignTokens.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and members
              Container(
                padding: EdgeInsets.all(DesignTokens.space16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(DesignTokens.radiusLg),
                    topRight: Radius.circular(DesignTokens.radiusLg),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: DesignTokens.textLg,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${members.length} members',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: DesignTokens.textSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Member avatars
                    Row(
                      children: members.take(3).map((member) {
                        return Container(
                          margin: EdgeInsets.only(left: 4.w),
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              member['avatar'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              // Budget progress
              Padding(
                padding: EdgeInsets.all(DesignTokens.space16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Spent',
                          style: TextStyle(
                            fontSize: DesignTokens.textSm,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '\$${budget['totalSpent'].toStringAsFixed(2)} / \$${budget['totalBudget'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: DesignTokens.textBase,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: DesignTokens.borderRadiusSm,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8.h,
                        backgroundColor: AppColors.border.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation(
                          progress > 0.8 ? AppColors.error : AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: DesignTokens.space16),
                    
                    // Member spending
                    ...members.map((member) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                member['avatar'],
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              member['name'],
                              style: TextStyle(fontSize: DesignTokens.textSm),
                            ),
                          ),
                          Text(
                            '\$${member['spent'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: DesignTokens.textSm,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showJoinBudgetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Shared Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the invitation code you received',
              style: TextStyle(fontSize: DesignTokens.textSm),
            ),
            SizedBox(height: DesignTokens.space16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter code',
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DesignTokens.textLg,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Would join budget here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Join', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCreateBudgetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: DesignTokens.space20,
          right: DesignTokens.space20,
          top: DesignTokens.space20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Shared Budget',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Budget Name',
                hintText: 'e.g., Family Monthly Budget',
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
            ),
            SizedBox(height: DesignTokens.space12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Total Amount',
                hintText: '\$1000',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: DesignTokens.space12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'What is this budget for?',
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
              maxLines: 2,
            ),
            SizedBox(height: DesignTokens.space20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Would create budget and show invitation screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: DesignTokens.space16),
                  shape: RoundedRectangleBorder(
                    borderRadius: DesignTokens.borderRadiusMd,
                  ),
                ),
                child: const Text(
                  'Create & Invite Members',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: DesignTokens.space16),
          ],
        ),
      ),
    );
  }
}
