import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/const/colors.dart';
import '../../../../../shared/const/app_strings.dart';
import '../../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_event.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    final socials = [
      {'icon': 'google.png', 'color': AppColors.googleRed},
      {'icon': 'facebook.png', 'color': AppColors.facebookBlue},
      {'icon': 'tiktok.png', 'color': AppColors.tiktokBlack},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socials.map((social) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: _buildSocialButton(
            context,
            social['icon'] as String,
            social['color'] as Color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialButton(BuildContext context, String icon, Color color) {
    return InkWell(
      onTap: () {
        if (icon == 'google.png') {
          // Dispatch Google sign‑in request via LoginBloc
          // TODO: Implement actual Google Sign-In to get ID token
          context.read<LoginBloc>().add(const GoogleSignInRequested(idToken: "placeholder_token"));
        } else {
          AppSnackBar.showInfo(context, message: AppStrings.featureComingSoon);
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/$icon',
            width: 30.w,
            height: 30.h,
          ),
        ),
      ),
    );
  }
}
