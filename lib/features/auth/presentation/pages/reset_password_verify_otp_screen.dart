import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/style/app_styles.dart';
import '../../../../shared/utils/routes.dart';
import '../blocs/password/password_bloc.dart';
import '../blocs/password/password_event.dart';
import '../blocs/password/password_state.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/otp_text_form.dart';

class ResetPasswordVerifyOtpScreen extends StatelessWidget {
  final String? resetToken;

  const ResetPasswordVerifyOtpScreen({super.key, this.resetToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PasswordBloc>(),
      child: _ResetPasswordVerifyOtpContent(resetToken: resetToken),
    );
  }
}

class _ResetPasswordVerifyOtpContent extends StatelessWidget {
  final String? resetToken;
  _ResetPasswordVerifyOtpContent({this.resetToken});

  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndSubmit(BuildContext context, String? resetToken) {
    AppSnackBar.hide(context);
    if (_formKey.currentState!.validate()) {
      context.read<PasswordBloc>().add(ResetPasswordOtpRequested(
          resetToken: resetToken ?? '', otp: _otpController.text.trim()));
    } else {
      AppSnackBar.showError(context, message: AppStrings.errorEnterOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<PasswordBloc, PasswordState>(
          listener: (context, state) {
            AppSnackBar.hide(context);
            if (state is PasswordResetOtpVerified) {
              // AppSnackBar.showSuccess(context, message: state.message); // Message might not be available or needed
              // Navigate to finish password reset with token
              context.pushReplacement(
                AppRoutes.resetPasswordFinish,
                extra: resetToken, // Pass the token (or the one from state if updated)
              );
            } else if (state is PasswordFailure) {
              AppSnackBar.showError(context, message: state.message);
            }
          },
          builder: (context, state) {
            return Center(
              child: SizedBox(
                width: 290.w,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 120.h),
                              Text(AppStrings.otpVerification,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.styleSemiBold25(context)),
                              SizedBox(height: 30),
                              Text(AppStrings.otpVerificationDescription,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.styleNormal13(context)
                                      .copyWith(color: AppColors.greyDark)),
                              SizedBox(height: 60.h),
                              OtpInputField(
                                onCompleted: () {
                                  _validateAndSubmit(context, resetToken ?? "");
                                },
                                otpController: _otpController,
                              ),
                              SizedBox(height: 40),
                              PrimaryButton(
                                text: AppStrings.resetPassword,
                                isLoading: state is PasswordLoading,
                                onPressed: () => _validateAndSubmit(
                                    context, resetToken ?? ""),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                      if (!isKeyboardOpen)
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              AppStrings.backToLogin,
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      if (!isKeyboardOpen) SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
