import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../const/colors.dart';

class NotchBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int? notificationBadgeCount;

  const NotchBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationBadgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Custom shape background
          ClipPath(
            clipper: BottomNavClipper(),
            child: Container(
              height: 75.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),

          // Navigation items
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 75.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    isActive: currentIndex == 0,
                  ),
                  _buildNavItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Analytics',
                    index: 1,
                    isActive: currentIndex == 1,
                  ),
                  // Spacer for center FAB
                  SizedBox(width: 70.w),
                  _buildNavItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Budgets',
                    index: 2,
                    isActive: currentIndex == 2,
                  ),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 3,
                    isActive: currentIndex == 3,
                    badgeCount: notificationBadgeCount,
                  ),
                ],
              ),
            ),
          ),

          // Center FAB
          Positioned(
            top: -15.h,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onTap(4); // Index 4 for Add action
              },
              child: Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    int? badgeCount,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isActive) HapticFeedback.lightImpact();
          onTap(index);
        },
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(isActive ? 8.w : 0),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      icon,
                      size: isActive ? 26.sp : 24.sp,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                  if (badgeCount != null && badgeCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.w,
                          minHeight: 16.w,
                        ),
                        child: Text(
                          badgeCount > 9 ? '9+' : badgeCount.toString(),
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isActive ? 11.sp : 10.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary.withValues(alpha: 0.6),
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom clipper for the notch shape
class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    
    // Control points for the smooth notch
    final double center = width / 2;
    final double notchRadius = 38.0; // Slightly wider for the FAB
    final double notchDepth = 45.0; // Deep enough for the button
    
    path.lineTo(center - notchRadius * 1.8, 0);
    
    // First curve down (left shoulder)
    path.cubicTo(
      center - notchRadius, 0, // Control point 1
      center - notchRadius * 0.8, notchDepth * 0.8, // Control point 2
      center, notchDepth, // End point (bottom center)
    );
    
    // Second curve up (right shoulder)
    path.cubicTo(
      center + notchRadius * 0.8, notchDepth * 0.8, // Control point 1
      center + notchRadius, 0, // Control point 2
      center + notchRadius * 1.8, 0, // End point
    );
    
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

