import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/utils/routes.dart';
import '../blocs/register/register_bloc.dart';
import '../blocs/register/register_event.dart';
import '../blocs/register/register_state.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/customer_text_form.dart';
import '../widgets/components/auth_header.dart';
import '../widgets/components/auth_footer.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterBloc>(),
      child: const _RegisterContent(),
    );
  }
}

class _RegisterContent extends StatefulWidget {
  const _RegisterContent();

  @override
  State<_RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<_RegisterContent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSignup(BuildContext context) {
    AppSnackBar.hide(context);
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(RegisterRequested(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: "", // Optional or add field
            mobile: null, // Optional or add field
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) async {
          AppSnackBar.hide(context);
          if (state is RegisterSuccess) {
            AppSnackBar.showSuccess(context,
                message: "${AppStrings.welcome} ${state.email}");
            // Navigate to OTP screen with email
            context.pushReplacement(
              AppRoutes.otpConfirm,
              extra: _emailController.text.trim(),
            );
          } else if (state is RegisterFailure) {
            AppSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background,
                  AppColors.primaryLight.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20.h),

                            // Header Section
                            const AuthHeader(
                              icon: Icons.person_add_rounded,
                              title: AppStrings.createAccount,
                              subtitle: AppStrings.joinUs,
                            ),

                            SizedBox(height: 40.h),

                            // Form Fields
                            _buildFormFields(context),

                            SizedBox(height: 32.h),

                            // Sign Up Button
                            _buildSignUpButton(state),

                            SizedBox(height: 24.h),

                            // Back to Login
                            if (!isKeyboardOpen)
                              AuthFooter(
                                text: AppStrings.alreadyHaveAccount,
                                actionText: AppStrings.signIn,
                                onPressed: () => context.pop(),
                              ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        CustomerTextForm(
          name: AppStrings.username,
          isPassword: false,
          controller: _usernameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.errorEnterUsername;
            }
            return null;
          },
          onFieldSubmitted: () {},
        ),
        SizedBox(height: 16.h),
        CustomerTextForm(
          name: AppStrings.email,
          isPassword: false,
          controller: _emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.errorEnterEmail;
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return AppStrings.errorInvalidEmail;
            }
            return null;
          },
          onFieldSubmitted: () {},
        ),
        SizedBox(height: 16.h),
        CustomerTextForm(
          name: AppStrings.password,
          isPassword: true,
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.errorEnterPassword;
            }
            if (value.length < 6) {
              return AppStrings.errorShortPassword;
            }
            return null;
          },
          onFieldSubmitted: () {},
        ),
        SizedBox(height: 16.h),
        CustomerTextForm(
          name: AppStrings.confirmPassword,
          isPassword: true,
          controller: _confirmPasswordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.errorConfirmPassword;
            }
            if (value != _passwordController.text) {
              return AppStrings.errorPasswordMismatch;
            }
            return null;
          },
          onFieldSubmitted: () => _validateAndSignup(context),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(RegisterState state) {
    return PrimaryButton(
      text: AppStrings.signUp,
      isLoading: state is RegisterLoading,
      onPressed: () => _validateAndSignup(context),
    );
  }
}
