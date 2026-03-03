import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import '../../../../shared/const/colors.dart';
import '../../../auth/presentation/blocs/security/security_bloc.dart';
import '../../../auth/presentation/blocs/security/security_event.dart';
import '../../../auth/presentation/blocs/security/security_state.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  final _tokenController = TextEditingController();
  bool _setupInitiated = false;

  @override
  void initState() {
    super.initState();
    context.read<SecurityBloc>().add(Setup2FARequested());
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, state) {
        if (state is SecurityFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Text(
              "Setup 2FA",
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(SecurityState state) {
    if (state is SecurityLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TwoFactorSetupInitiated) {
      return _buildSetupStep(state);
    }

    if (state is TwoFactorEnabled) {
      return _buildSuccessStep(state.backupCodes);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16.h),
          const Text("Failed to initiate 2FA setup"),
          TextButton(
            onPressed: () => context.read<SecurityBloc>().add(Setup2FARequested()),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupStep(TwoFactorSetupInitiated state) {
    // QR code is usually base64 "data:image/png;base64,..."
    final qrBase64 = state.response.qrCode.split(',').last;
    final qrImage = base64Decode(qrBase64);

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "1. Scan QR Code",
            style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            "Use Google Authenticator or Authy to scan this code",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Image.memory(qrImage, width: 200.w, height: 200.h),
          ),
          SizedBox(height: 24.h),
          Text(
            "Or enter secret key manually:",
            style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SelectableText(
            state.response.secret,
            style: GoogleFonts.robotoMono(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            "2. Enter Verification Code",
            style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _tokenController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: GoogleFonts.poppins(fontSize: 24.sp, letterSpacing: 8),
            decoration: InputDecoration(
              hintText: "000000",
              hintStyle: GoogleFonts.poppins(color: AppColors.border),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              if (_tokenController.text.length == 6) {
                context.read<SecurityBloc>().add(Verify2FARequested(_tokenController.text));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 56.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: const Text("Verify & Enable", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep(List<String> backupCodes) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          SizedBox(height: 24.h),
          Text(
            "2FA Enabled Successfully!",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.h),
          Text(
            "Save these backup codes in a safe place. You can use them to access your account if you lose your phone.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 32.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 8,
              ),
              itemCount: backupCodes.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    backupCodes[index],
                    style: GoogleFonts.robotoMono(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 56.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: const Text("Done", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
