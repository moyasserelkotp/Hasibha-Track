import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _nameController.text = authState.user.fullName; // This would be user.name in real implementation
      _emailController.text = 'user@example.com'; // This would come from user data
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _saveProfile() {
    AppSnackBar.showSuccess(context, message: 'Profile updated successfully!');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.space20),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                      boxShadow: DesignTokens.shadowLg,
                    ),
                    child: ClipOval(
                      child: _profileImage != null
                          ? Image.file(_profileImage!, fit: BoxFit.cover)
                          : Container(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.person,
                                size: 60.sp,
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: DesignTokens.space32),
            
            // Account Statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Transactions', '156', Icons.receipt_long),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildStatCard('Days Active', '45', Icons.calendar_today),
                ),
              ],
            ),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Budgets', '8', Icons.account_balance_wallet),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildStatCard('Savings Goals', '5', Icons.savings),
                ),
              ],
            ),
            
            SizedBox(height: DesignTokens.space24),
            
            // Personal Information
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: DesignTokens.textXl,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            SizedBox(height: DesignTokens.space16),
            
            // Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
            ),
            
            SizedBox(height: DesignTokens.space16),
            
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
              enabled: false, // Email usually can't be changed
            ),
            
            SizedBox(height: DesignTokens.space16),
            
            // Phone Field
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: DesignTokens.borderRadiusMd,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            
            SizedBox(height: DesignTokens.space24),
            
            // Save Button
            PrimaryButton(
              text: 'Save Changes',
              onPressed: _saveProfile,
            ),
            
            SizedBox(height: DesignTokens.space16),
            
            // Delete Account
            TextButton(
              onPressed: () {
                _showDeleteAccountDialog();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.space12),
      padding: EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: DesignTokens.borderRadiusLg,
        boxShadow: DesignTokens.coloredShadow(AppColors.primary, opacity: 0.3),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32.sp),
          SizedBox(height: DesignTokens.space8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: DesignTokens.text3xl,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: DesignTokens.textSm,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle account deletion
              Navigator.pop(context);
              AppSnackBar.showError(context, message: 'Account deletion not implemented yet');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
