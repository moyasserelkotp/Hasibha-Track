import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors.dart';
import '../../const/design_tokens.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return DesignTokens.enhancedShimmerGradient.createShader(
              Rect.fromLTWH(
                bounds.width * _animation.value,
                0,
                bounds.width,
                bounds.height,
              ),
            );
          },
          child: widget.child,
        );
      },
    );
  }
}

/// A generic placeholder box for skeleton loading
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
      ),
    );
  }
}

/// Skeleton loader for the Home Screen
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ShimmerLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 100.w, height: 16.h),
                      SizedBox(height: 8.h),
                      ShimmerBox(width: 150.w, height: 24.h),
                    ],
                  ),
                  ShimmerBox(width: 40.w, height: 40.w, borderRadius: 20.r),
                ],
              ),
              SizedBox(height: 30.h),
              
              // Balance Card
              ShimmerBox(width: double.infinity, height: 220.h, borderRadius: 24.r),
              SizedBox(height: 30.h),
              
              // Quick Actions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerBox(width: 120.w, height: 20.h),
                  ShimmerBox(width: 60.w, height: 20.h),
                ],
              ),
              SizedBox(height: 16.h),
              
              // Quick Actions Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return ShimmerBox(width: double.infinity, height: double.infinity, borderRadius: 20.r);
                },
              ),
              
              SizedBox(height: 30.h),
              
              // Recent Transactions Header
              ShimmerBox(width: 180.w, height: 20.h),
              SizedBox(height: 16.h),
              
              // Transaction List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ShimmerBox(width: double.infinity, height: 80.h, borderRadius: 16.r),
                  );
                },
              ),
            ],
          ),
        ),
      );
  }
}

/// Skeleton loader for the Analytics Screen
class AnalyticsSkeleton extends StatelessWidget {
  const AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: ShimmerLoading(
        child: Column(
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(child: ShimmerBox(width: double.infinity, height: 100.h, borderRadius: 16.r)),
                SizedBox(width: 12.w),
                Expanded(child: ShimmerBox(width: double.infinity, height: 100.h, borderRadius: 16.r)),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: ShimmerBox(width: double.infinity, height: 100.h, borderRadius: 16.r)),
                SizedBox(width: 12.w),
                Expanded(child: ShimmerBox(width: double.infinity, height: 100.h, borderRadius: 16.r)),
              ],
            ),
            SizedBox(height: 30.h),
            
            // Chart Title
            Align(alignment: Alignment.centerLeft, child: ShimmerBox(width: 200.w, height: 24.h)),
            SizedBox(height: 16.h),
            
            // Chart
            ShimmerBox(width: double.infinity, height: 300.h, borderRadius: 16.r),
            SizedBox(height: 30.h),
            
            // Category List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      ShimmerBox(width: 40.w, height: 40.w, borderRadius: 20.r),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: 120.w, height: 16.h),
                          SizedBox(height: 4.h),
                          ShimmerBox(width: 80.w, height: 12.h),
                        ],
                      ),
                      const Spacer(),
                      ShimmerBox(width: 80.w, height: 16.h),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader for the Debt Screen
class DebtSkeleton extends StatelessWidget {
  const DebtSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: ShimmerLoading(
        child: Column(
          children: [
            // Summary Card
            ShimmerBox(width: double.infinity, height: 180.h, borderRadius: 24.r),
            SizedBox(height: 24.h),
            
            // Debt List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ShimmerBox(width: double.infinity, height: 100.h, borderRadius: 16.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
