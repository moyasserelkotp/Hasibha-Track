import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/style/app_styles.dart';
import '../blocs/password/password_bloc.dart';
import '../blocs/password/password_event.dart';
import '../blocs/password/password_state.dart';
import '../validators/auth_validators.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/customer_text_form.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PasswordBloc>(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit(BuildContext context) {
    AppSnackBar.hide(context);
    if (_formKey.currentState!.validate()) {
      context.read<PasswordBloc>().add(ChangePasswordRequested(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppStrings.changePassword, style: AppStyles.styleSemiBold21(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<PasswordBloc, PasswordState>(
        listener: (context, state) {
          AppSnackBar.hide(context);
          
          if (state is PasswordChangeSuccess) {
            AppSnackBar.showSuccess(context, message: state.message);
            context.pop();
          } else if (state is PasswordFailure) {
            AppSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.h),
                  
                  // Instructions
                  Text(
                    'Enter your current password and choose a new password.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Current Password
                  CustomerTextForm(
                    name: 'Current Password',
                    isPassword: true,
                    controller: _currentPasswordController,
                    validator: (value) => AuthValidators.validatePassword(value),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // New Password
                  CustomerTextForm(
                    name: 'New Password',
                    isPassword: true,
                    controller: _newPasswordController,
                    validator: (value) => AuthValidators.validatePassword(value),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Confirm New Password
                  CustomerTextForm(
                    name: AppStrings.confirmPassword,
                    isPassword: true,
                    controller: _confirmPasswordController,
                    validator: (value) => AuthValidators.validateConfirmPassword(
                      _newPasswordController.text,
                      value,
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Submit Button
                  PrimaryButton(
                    text: AppStrings.changePassword,
                    isLoading: state is PasswordLoading,
                    onPressed: () => _validateAndSubmit(context),
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
