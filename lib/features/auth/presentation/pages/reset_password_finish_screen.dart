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

class ResetPasswordFinishScreen extends StatelessWidget {
  final String? email;

  const ResetPasswordFinishScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordBloc>(
      create: (context) => di.sl<PasswordBloc>(),
      child: _ResetPasswordFinishContent(email: email),
    );
  }
}

class _ResetPasswordFinishContent extends StatefulWidget {
  final String? email;
  const _ResetPasswordFinishContent({this.email});

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
        backgroundColor: AppColors.background,
        body: BlocConsumer<PasswordBloc, PasswordState>(
          listener: (context, state) {
            AppSnackBar.hide(context);
            if (state is PasswordResetSuccess) {
              AppSnackBar.showSuccess(context,
                  message: AppStrings.successPasswordReset);
              // Navigate to login after successful password reset
              context.go(AppRoutes.login);
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
                                  style: AppStyles.styleSemiBold25(context)),
                              SizedBox(height: 30),
                              Text(AppStrings.resetPasswordFinishDescription,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.styleNormal13(context)
                                      .copyWith(color: AppColors.greyDark)),
                              SizedBox(height: 60.h),
                              // Code Field
                              CustomerTextForm(
                                isPassword: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.errorRequiredField;
                                  }
                                  return null;
                                },
                                name: "Reset Code", // Add to strings later
                                controller: _codeController,
                                onFieldSubmitted: () {},
                              ),
                              SizedBox(height: 12),
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
                              SizedBox(height: 12),
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
