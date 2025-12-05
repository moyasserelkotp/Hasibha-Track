import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../const/colors.dart';
import '../../utils/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35.sp, color: AppColors.primary),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Budget App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage Your Finances',
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.home);
            },
          ),
          Divider(),
          _buildSectionHeader('Features'),
          _buildDrawerItem(
            context,
            icon: Icons.receipt_long,
            title: 'Expenses',
            subtitle: 'Track your spending',
            onTap: () {
              Navigator.pop(context);
              // Navigate to expenses (would need to create this route)
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.savings,
            title: 'Budget',
            subtitle: 'Manage budgets',
            onTap: () {
              Navigator.pop(context);
              // Would navigate to budget screen
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.account_balance_wallet,
            title: 'Debt Tracking',
            subtitle: 'Manage debts & loans',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.debts);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.trending_up,
            title: 'Savings Goals',
            subtitle: 'Track your goals',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.savings);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart,
            title: 'Analytics',
            subtitle: 'View reports',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.analytics);
            },
          ),
          Divider(),
          _buildSectionHeader('AI Features'),
          _buildDrawerItem(
            context,
            icon: Icons.smart_toy,
            title: 'AI Assistant',
            subtitle: 'Chat with AI advisor',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.aiChat);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.lightbulb_outline,
            title: 'AI Insights',
            subtitle: 'Smart recommendations',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.insights);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.local_offer,
            title: 'Offers & Deals',
            subtitle: 'Personalized offers',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.offers);
            },
          ),
          Divider(),
          _buildSectionHeader('Settings'),
          _buildDrawerItem(
            context,
            icon: Icons.download,
            title: 'Export Data',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.export);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.settings);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            )
          : null,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Budget App',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.account_balance_wallet, size: 48.sp, color: AppColors.primary),
      children: [
        Text('A comprehensive personal finance management application.'),
        SizedBox(height: 8.h),
        Text('Features:'),
        Text('• Expense Tracking'),
        Text('• Budget Management'),
        Text('• Debt Tracking'),
        Text('• Savings Goals'),
        Text('• Analytics & Reports'),
      ],
    );
  }
}
