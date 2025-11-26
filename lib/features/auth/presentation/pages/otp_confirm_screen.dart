import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/utils/routes.dart';
import '../blocs/register/register_bloc.dart';
import '../blocs/register/register_event.dart';
import '../blocs/register/register_state.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/otp_text_form.dart';

class OtpConfirmScreen extends StatelessWidget {
  final String email;
  const OtpConfirmScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterBloc>(),
      child: _OtpConfirmContent(email: email),
    );
  }
}

class _OtpConfirmContent extends StatelessWidget {
  final String email;
  _OtpConfirmContent({required this.email});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  void _otpConfirm(BuildContext context) async {
    AppSnackBar.hide(context);
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(OtpVerificationRequested(
            email: email,
            otp: _otpController.text,
          ));
    } else {
      AppSnackBar.showError(context, message: AppStrings.errorEnterOtp);
    }
  }

  void _otpResend(BuildContext context) async {
    context.read<RegisterBloc>().add(OtpResendRequested(email));
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (BuildContext context, state) {
          AppSnackBar.hide(context);
          if (state is OtpResent) {
            AppSnackBar.showSuccess(context, message: '${state.message}!');
          } else if (state is OtpVerified) {
            AppSnackBar.showSuccess(
                context, message: AppStrings.emailVerifiedSuccess);
            // Navigate to login and remove OTP screen from stack
            context.go(AppRoutes.login);
          } else if (state is OtpFailure) {
            AppSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40.h),
                      Center(
                        child: Text(
                          AppStrings.appName,
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Icon(
                          Icons.mail_outline,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        AppStrings.verifyEmailTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppStrings.enterOtpMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        email,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 30),
                      OtpInputField(
                        onCompleted: () {
                          _otpConfirm(context);
                        },
                        otpController: _otpController,
                      ),
                      const SizedBox(height: 30),
                      PrimaryButton(
                        text: AppStrings.verifyOtp,
                        isLoading: state is OtpVerifying || state is RegisterLoading,
                        onPressed: () {
                          _otpConfirm(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      if (!isKeyboardOpen)
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              _otpResend(context);
                            },
                            child: Text(
                              AppStrings.resendOtpPrompt,
                              style: GoogleFonts.poppins(
                                decoration: TextDecoration.underline,
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
            ),
          );
        },
      ),
    );
  }
}
