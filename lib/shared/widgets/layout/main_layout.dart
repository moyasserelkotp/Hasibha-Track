import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/app_strings.dart';
import '../../const/colors.dart';
import '../../const/design_tokens.dart';
import '../../const/text_styles.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Prevent unnecessary rebuilds by caching pages
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _HomePageWrapper(),
      _AnalyticsPageWrapper(),
      _BudgetsPageWrapper(),
      _ProfilePageWrapper(),
    ];

    _fabAnimationController = AnimationController(
      duration: DesignTokens.durationNormal,
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut),
    );

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusXl),
          ),
          child: BottomAppBar(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            elevation: 0,
            notchMargin: 8.0,
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 60.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    Icons.home_outlined,
                    Icons.home_rounded,
                    AppStrings.navHome,
                    0,
                  ),
                  _buildNavItem(
                    Icons.analytics_outlined,
                    Icons.analytics_rounded,
                    AppStrings.navAnalytics,
                    1,
                  ),
                  SizedBox(width: 60.w), // Space for FAB
                  _buildNavItem(
                    Icons.account_balance_wallet_outlined,
                    Icons.account_balance_wallet_rounded,
                    AppStrings.navBudgets,
                    2,
                  ),
                  _buildNavItem(
                    Icons.person_outline_rounded,
                    Icons.person_rounded,
                    AppStrings.navProfile,
                    3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add-expense');
          },
          elevation: 8,
          backgroundColor: AppColors.primary,
          child: Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
  ) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: DesignTokens.durationFast,
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: DesignTokens.durationFast,
                padding: EdgeInsets.all(isSelected ? 10.w : 8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  size: isSelected ? 26.sp : 24.sp,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: isSelected
                    ? AppTextStyles.bottomNavActive(context)
                    : AppTextStyles.bottomNavInactive(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wrapper widgets to prevent rebuilds
class _HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Import after creating the screen
    return Container(); // TODO: Replace with actual HomeScreen
  }
}

class _AnalyticsPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // TODO: Replace with AnalyticsDashboardScreen
  }
}

class _BudgetsPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // TODO: Replace with BudgetsScreen
  }
}

class _ProfilePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // TODO: Replace with ProfileScreen
  }
}
