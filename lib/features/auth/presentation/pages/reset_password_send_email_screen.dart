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
import '../blocs/password/password_bloc.dart';
import '../blocs/password/password_event.dart';
import '../blocs/password/password_state.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/customer_text_form.dart';
import '../widgets/components/auth_header.dart';

class ResetPasswordSendEmailScreen extends StatelessWidget {
  const ResetPasswordSendEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordBloc>(
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
      backgroundColor: AppColors.white,
      body: BlocConsumer<PasswordBloc, PasswordState>(
        listener: (context, state) {
          AppSnackBar.hide(context);
          if (state is PasswordResetEmailSent) {
            AppSnackBar.showSuccess(context,
                message: AppStrings.otpSentSuccess);
            context.pushReplacement(
              AppRoutes.resetPasswordConfirmOtp,
              extra: _emailController.text.trim(),
            );
          } else if (state is PasswordFailure) {
            AppSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 60.h),

                          // Logo + App Name + Reset Password label
                          const AuthHeader(
                            title: AppStrings.appName,
                            subtitle: AppStrings.resetPassword,
                          ),

                          SizedBox(height: 16.h),

                          // Description
                          Text(
                            AppStrings.resetPasswordDescription,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // Email field
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

                          SizedBox(height: 24.h),

                          // Reset Password button
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            AppStrings.backToLogin,
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
