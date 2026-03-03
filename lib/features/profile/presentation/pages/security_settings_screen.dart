import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/utils/routes.dart';
import '../../../auth/presentation/blocs/security/security_bloc.dart';
import '../../../auth/presentation/blocs/security/security_event.dart';
import '../../../auth/presentation/blocs/security/security_state.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = true;

  @override
  void initState() {
    super.initState();
    context.read<SecurityBloc>().add(Get2FAStatusRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SecurityBloc, SecurityState>(
      listener: (context, state) {
        if (state is SecurityFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
          );
        } else if (state is TwoFactorDisabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('2FA disabled successfully'), backgroundColor: Colors.green),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        appBar: AppBar(
          title: const Text('Security Settings'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1C1E),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<SecurityBloc, SecurityState>(
          builder: (context, state) {
            bool is2FAEnabled = false;
            if (state is TwoFactorStatusLoaded) {
              is2FAEnabled = state.status.enabled;
            }

            return ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                // Authentication Section
                _buildSectionHeader('Authentication'),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSecurityItem(
                        icon: Icons.fingerprint_rounded,
                        title: 'Biometric Authentication',
                        subtitle: 'Use FaceID or TouchID to log in',
                        trailing: Switch(
                          value: _biometricEnabled,
                          onChanged: (value) => setState(() => _biometricEnabled = value),
                          activeColor: const Color(0xFF00BFA5),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Divider(height: 1, color: Colors.grey[200]),
                      ),
                      _buildSecurityItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your login password',
                        onTap: () => context.push(AppRoutes.changePassword),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Divider(height: 1, color: Colors.grey[200]),
                      ),
                      _buildSecurityItem(
                        icon: Icons.verified_user_outlined,
                        title: 'Two-Factor Authentication',
                        subtitle: is2FAEnabled ? 'Enhanced security enabled' : 'Add an extra layer of security',
                        trailing: Switch(
                          value: is2FAEnabled,
                          onChanged: (value) {
                            if (value) {
                              context.push(AppRoutes.twoFactorSetup);
                            } else {
                              _showDisable2FADialog();
                            }
                          },
                          activeColor: const Color(0xFF00BFA5),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Devices Section
                _buildSectionHeader('Devices'),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _buildSecurityItem(
                    icon: Icons.devices_rounded,
                    title: 'Manage Devices',
                    subtitle: 'See devices logged into your account',
                    onTap: () => context.push(AppRoutes.devices),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDisable2FADialog() {
    final passwordController = TextEditingController();
    final tokenController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Disable 2FA"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter your password and current 2FA token to disable."),
            SizedBox(height: 16.h),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(
                labelText: "2FA Token (Optional)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              context.read<SecurityBloc>().add(Disable2FARequested(
                password: passwordController.text,
                token: tokenController.text.isEmpty ? null : tokenController.text,
              ));
              context.pop();
              context.read<SecurityBloc>().add(Get2FAStatusRequested());
            },
            child: const Text("Disable"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFF00BFA5).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: const Color(0xFF00BFA5), size: 22.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1C1E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
    );
  }
}
