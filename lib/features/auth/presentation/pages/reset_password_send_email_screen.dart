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
import '../widgets/customer_text_form.dart';

class ResetPasswordSendEmailScreen extends StatelessWidget {
  const ResetPasswordSendEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PasswordBloc>(),
      child: _ResetPasswordSendEmailContent(),
    );
  }
}

class _ResetPasswordSendEmailContent extends StatelessWidget {
  _ResetPasswordSendEmailContent();

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndSubmit(BuildContext context) {
    AppSnackBar.hide(context);
    if (_formKey.currentState!.validate()) {
      context
          .read<PasswordBloc>()
          .add(ResetPasswordEmailRequested(_emailController.text));
    } else {
      AppSnackBar.showError(context, message: AppStrings.errorInvalidEmail);
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
            if (state is PasswordResetEmailSent) {
              AppSnackBar.showSuccess(context,
                  message: AppStrings.otpSentSuccess);
              // Navigate to OTP verification screen with reset token
              context.pushReplacement(
                AppRoutes.resetPasswordConfirmOtp,
                extra: state.message, // This is the reset token
              );
            } else if (state is PasswordFailure) {
              AppSnackBar.showError(context, message: state.message);
            }
          },
          builder: (context, state) {
            return Center(
              child: SizedBox(
                width: 280.w,
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
                              Text(AppStrings.resetPassword,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  )),
                              SizedBox(height: 30),
                              Text(AppStrings.resetPasswordDescription,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.styleNormal13(context)
                                      .copyWith(color: AppColors.greyDark)),
                              SizedBox(height: 60.h),
                              CustomerTextForm(
                                name: AppStrings.email,
                                isPassword: false,
                                controller: _emailController,
                                onFieldSubmitted: () {
                                  _validateAndSubmit(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.errorEnterEmail;
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return AppStrings.errorInvalidEmail;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 40),
                              PrimaryButton(
                                text: AppStrings.resetPassword,
                                isLoading: state is PasswordLoading,
                                onPressed: () => _validateAndSubmit(context),
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
