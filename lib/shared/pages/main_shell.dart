import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/enhanced_home_screen.dart';
import '../../features/analytics/presentation/pages/analytics_dashboard_screen.dart';
import '../../features/budget/presentation/pages/budget_dashboard_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../widgets/navigation/notch_bottom_nav_bar.dart';
import '../widgets/buttons/ai_floating_button.dart';
import '../utils/routes.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../di/injection.dart' as di;

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _pages = [
    const EnhancedHomeScreen(), // Index 0 - Orders
    const AnalyticsDashboardScreen(), // Index 1 - Product
    const EnhancedHomeScreen(), // Index 2 - Dashboard (center button)
    const BudgetDashboardScreen(), // Index 3 - Category
    const ProfileScreen(), // Index 4 - Settings
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => di.sl<HomeCubit>(),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
          children: _pages,
        ),
      ),
      bottomNavigationBar: NotchBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        notificationBadgeCount: 0, // TODO: Connect to real notification count
      ),
      floatingActionButton: const AiFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
