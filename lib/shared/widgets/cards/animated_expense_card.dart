import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';

class AnimatedExpenseCard extends StatefulWidget {
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final int index;

  const AnimatedExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.icon,
    required this.color,
    this.onTap,
    this.index = 0,
  });

  @override
  State<AnimatedExpenseCard> createState() => _AnimatedExpenseCardState();
}

class _AnimatedExpenseCardState extends State<AnimatedExpenseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: DesignTokens.space12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: DesignTokens.borderRadiusLg,
              boxShadow: DesignTokens.shadowMd,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: DesignTokens.borderRadiusLg,
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.space16),
                  child: Row(
                    children: [
                      // Icon Container with gradient
                      Hero(
                        tag: 'expense_icon_${widget.title}_${widget.date}',
                        child: Container(
                          width: 56.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.color,
                                widget.color.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: DesignTokens.borderRadiusMd,
                            boxShadow: DesignTokens.coloredShadow(
                              widget.color,
                              opacity: 0.3,
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: DesignTokens.space16),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: DesignTokens.textBase,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  widget.category,
                                  style: TextStyle(
                                    fontSize: DesignTokens.textSm,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.calendar_today,
                                  size: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${widget.date.day}/${widget.date.month}',
                                  style: TextStyle(
                                    fontSize: DesignTokens.textSm,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Amount
                      Hero(
                        tag: 'expense_amount_${widget.title}_${widget.date}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            '\$${widget.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: DesignTokens.textLg,
                              fontWeight: FontWeight.bold,
                              color: widget.color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
