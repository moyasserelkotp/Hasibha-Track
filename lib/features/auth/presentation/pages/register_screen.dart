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
import '../widgets/components/auth_divider.dart';
import '../widgets/components/social_login_row.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(create: (context) => di.sl<RegisterBloc>()),
        BlocProvider<SmsBloc>(create: (context) => di.sl<SmsBloc>()),
      ],
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _phoneVerificationToken;
  bool _otpSent = false;

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
      if (_phoneController.text.isNotEmpty && _phoneVerificationToken == null) {
        AppSnackBar.showError(context, message: "Please verify your phone number first");
        return;
      }
      
      context.read<RegisterBloc>().add(RegisterRequested(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
            phone: _phoneController.text.trim(),
            phoneVerificationToken: _phoneVerificationToken,
          ));
    }
  }

  void _sendOtp() {
    if (_phoneController.text.isEmpty) {
      AppSnackBar.showError(context, message: "Please enter your phone number");
      return;
    }
    context.read<SmsBloc>().add(SendSmsRequested(phone: _phoneController.text.trim()));
  }

  void _verifyOtp() {
    if (_otpController.text.isEmpty) {
      AppSnackBar.showError(context, message: "Please enter the OTP");
      return;
    }
    context.read<SmsBloc>().add(VerifySmsRequested(
      phone: _phoneController.text.trim(),
      code: _otpController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                AppSnackBar.showSuccess(context, message: "Welcome! Account created successfully");
                context.go(AppRoutes.home);
              } else if (state is RegisterFailure) {
                AppSnackBar.showError(context, message: state.message);
              }
            },
          ),
          BlocListener<SmsBloc, SmsState>(
            listener: (context, state) {
              if (state is SmsCodeSent) {
                AppSnackBar.showSuccess(context, message: state.message);
                setState(() => _otpSent = true);
              } else if (state is SmsVerified) {
                AppSnackBar.showSuccess(context, message: "Phone verified successfully");
                setState(() => _phoneVerificationToken = state.phoneVerificationToken);
              } else if (state is SmsFailure) {
                AppSnackBar.showError(context, message: state.errorMessage);
              }
            },
          ),
        ],
        builder: (context, state) {
          return Container(
            color: AppColors.white,
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
                              title: AppStrings.appName,
                              subtitle: AppStrings.appTagline,
                            ),

                            SizedBox(height: 40.h),

                            // Form Fields
                            _buildFormFields(context),

                            SizedBox(height: 32.h),

                            // Sign Up Button
                            _buildSignUpButton(state),

                            SizedBox(height: 20.h),

                            // Divider
                            const AuthDivider(),

                            SizedBox(height: 20.h),

                            // Social Login
                            const SocialLoginRow(),

                            if (!isKeyboardOpen) ...[
                              SizedBox(height: 24.h),
                              AuthFooter(
                                text: AppStrings.alreadyHaveAccount,
                                actionText: AppStrings.signIn,
                                onPressed: () => context.pop(),
                              ),
                            ],

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
    return BlocBuilder<SmsBloc, SmsState>(
      builder: (context, smsState) {
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
            Row(
              children: [
                Expanded(
                  child: CustomerTextForm(
                    name: "Phone Number",
                    isPassword: false,
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter phone number";
                      }
                      return null;
                    },
                    onFieldSubmitted: () {},
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _phoneVerificationToken != null || smsState is SmsLoading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: smsState is SmsLoading && !_otpSent
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_phoneVerificationToken != null ? "Verified" : "Send", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            if (_otpSent && _phoneVerificationToken == null) ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomerTextForm(
                      name: "OTP Code",
                      isPassword: false,
                      controller: _otpController,
                      onFieldSubmitted: () {},
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: smsState is SmsLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: smsState is SmsLoading && _otpSent
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Verify", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
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
      },
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
