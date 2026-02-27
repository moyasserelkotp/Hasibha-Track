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

class ResetPasswordFinishScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const ResetPasswordFinishScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final email = data?['email'] as String?;
    final code = data?['code'] as String?;

    return BlocProvider<PasswordBloc>(
      create: (context) => di.sl<PasswordBloc>(),
      child: _ResetPasswordFinishContent(email: email, initialCode: code),
    );
  }
}

class _ResetPasswordFinishContent extends StatefulWidget {
  final String? email;
  final String? initialCode;
  const _ResetPasswordFinishContent({this.email, this.initialCode});

  @override
  State<_ResetPasswordFinishContent> createState() =>
      _ResetPasswordFinishContentState();
}

class _ResetPasswordFinishContentState
    extends State<_ResetPasswordFinishContent> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null) {
      _codeController.text = widget.initialCode!;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit(BuildContext context) {
    AppSnackBar.hide(context);
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        context.read<PasswordBloc>().add(ResetPasswordRequested(
            email: widget.email ?? '',
            code: _codeController.text.trim(),
            newPassword: _passwordController.text.trim()));
      } else {
        AppSnackBar.showError(context,
            message: AppStrings.errorPasswordMismatch);
      }
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
          if (state is PasswordResetSuccess) {
            AppSnackBar.showSuccess(context,
                message: AppStrings.successPasswordReset);
            context.go(AppRoutes.login);
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
                            AppStrings.resetPasswordFinishDescription,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // OTP / Code Field
                          CustomerTextForm(
                            isPassword: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.errorRequiredField;
                              }
                              return null;
                            },
                            name: AppStrings.enterOtp,
                            controller: _codeController,
                            onFieldSubmitted: () {},
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12.h),

                          // Password Field
                          CustomerTextForm(
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.errorRequiredField;
                              } else if (value.length < 6) {
                                return AppStrings.errorInvalidPassword;
                              }
                              return null;
                            },
                            name: AppStrings.password,
                            controller: _passwordController,
                            onFieldSubmitted: () {},
                          ),
                          SizedBox(height: 12.h),

                          // Confirm Password Field
                          CustomerTextForm(
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.errorRequiredField;
                              } else if (value.length < 6) {
                                return AppStrings.errorInvalidPassword;
                              }
                              return null;
                            },
                            name: AppStrings.confirmPassword,
                            controller: _confirmPasswordController,
                            onFieldSubmitted: () {
                              _validateAndSubmit(context);
                            },
                          ),

                          SizedBox(height: 32.h),

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
