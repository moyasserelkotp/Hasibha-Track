import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/utils/routes.dart';

class SharedBudgetsScreen extends StatelessWidget {
  const SharedBudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - would come from Firebase in real implementation
    final hasSharedBudgets = false;

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
              // Navigate to join budget with code
              _showJoinBudgetDialog(context);
            },
          ),
        ],
      ),
      body: hasSharedBudgets ? _buildBudgetsList() : _buildEmptyState(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to create shared budget
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
    return ListView(
      padding: EdgeInsets.all(DesignTokens.space16),
      children: [
        // Would show list of shared budgets
        const Center(child: Text('Shared budgets list would appear here')),
      ],
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
          PrimaryButton(
            text: 'Join',
            onPressed: () {
              Navigator.pop(context);
              // Would join budget here
            },
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
            PrimaryButton(
              text: 'Create & Invite Members',
              onPressed: () {
                Navigator.pop(context);
                // Would create budget and show invitation screen
              },
            ),
            SizedBox(height: DesignTokens.space16),
          ],
        ),
      ),
    );
  }
}
