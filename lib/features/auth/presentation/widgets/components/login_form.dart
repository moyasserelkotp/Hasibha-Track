import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../shared/const/app_strings.dart';
import '../../../../../shared/const/colors.dart';
import '../../../../../shared/utils/routes.dart';
import '../../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_event.dart';
import '../../blocs/login/login_state.dart';
import '../../validators/auth_validators.dart';
import '../customer_text_form.dart';
import 'auth_divider.dart';
import 'auth_footer.dart';
import 'auth_header.dart';
import 'social_login_row.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndLogin(BuildContext context) {
    AppSnackBar.hide(context);
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginRequested(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        AppSnackBar.hide(context);

        context.go(AppRoutes.home);

        if (state is LoginSuccess) {
          // Navigation will be handled by AuthBloc listener in main app
          context.go(AppRoutes.home);
        } else if (state is LoginFailure) {
          AppSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),

              // Logo and Welcome Text
              const AuthHeader(
                icon: Icons.account_balance_wallet_rounded,
                title: AppStrings.welcomeBack,
                subtitle: AppStrings.signInToContinue,
              ),

              SizedBox(height: 48.h),

              // Username Field
              _buildUsernameField(),

              SizedBox(height: 7.h),

              // Password Field
              _buildPasswordField(),

              SizedBox(height: 12.h),

              // Forgot Password
              _buildForgotPassword(),

              SizedBox(height: 20.h),

              // Login Button
              _buildLoginButton(state),

              SizedBox(height: 20.h),

              // Divider
              const AuthDivider(),

              SizedBox(height: 20.h),

              // Social Login
              const SocialLoginRow(),

              if (!isKeyboardOpen) ...[
                SizedBox(height: 30.h),
                AuthFooter(
                  text: AppStrings.dontHaveAccount,
                  actionText: AppStrings.signUp,
                  onPressed: () => context.push(AppRoutes.register),
                ),
                SizedBox(height: 20.h),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsernameField() {
    return CustomerTextForm(
      name: AppStrings.email,
      controller: _usernameController,
      validator: (value) => AuthValidators.validateUsername(value),
      onFieldSubmitted: () => _validateAndLogin(context),
    );
  }

  Widget _buildPasswordField() {
    return CustomerTextForm(
      name: AppStrings.password,
      controller: _passwordController,
      isPassword: true,
      validator: (value) => AuthValidators.validatePassword(value),
      onFieldSubmitted: () => _validateAndLogin(context),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.push(AppRoutes.resetPasswordSendEmail),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          AppStrings.forgotPassword,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginState state) {
    return PrimaryButton(
      text: AppStrings.signIn,
      isLoading: state is LoginLoading,
      onPressed: () => _validateAndLogin(context),
    );
  }
}
