import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Nav bar background with subtle shadow
          Positioned.fill(
            child: PhysicalShape(
              clipper: BottomNavClipper(),
              color: Colors.white,
              elevation: 6,
              shadowColor: Colors.black.withValues(alpha: 0.15),
              child: const SizedBox.expand(),
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
                  SizedBox(width: 65.w),
                  _buildNavItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Budgets',
                    index: 3,
                    isActive: currentIndex == 3,
                  ),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 4,
                    isActive: currentIndex == 4,
                    badgeCount: notificationBadgeCount,
                  ),
                ],
              ),
            ),
          ),

          // Center FAB
          Positioned(
            top: -12.h,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
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
        onTap: () => onTap(index),
        splashColor: AppColors.primary.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 24.sp,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.5),
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary.withValues(alpha: 0.5),
                ),
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

    final double centerX = size.width / 2;
    // Notch radius is FAB radius (55/2) + clean gap (8)
    final double notchRadius = 55.w / 2 + 8.w;
    final double notchDepth = 35.h;

    // Start top-left (flat edge)
    path.moveTo(0, 0);
    
    // Line to the start of the notch curve
    path.lineTo(centerX - notchRadius - 10.w, 0);

    // Smooth curve into the notch
    path.cubicTo(
      centerX - notchRadius,
      0,
      centerX - notchRadius + 5.w,
      notchDepth,
      centerX,
      notchDepth,
    );

    // Smooth curve out of the notch
    path.cubicTo(
      centerX + notchRadius - 5.w,
      notchDepth,
      centerX + notchRadius,
      0,
      centerX + notchRadius + 10.w,
      0,
    );

    // Line to top-right
    path.lineTo(size.width, 0);

    // Complete shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

