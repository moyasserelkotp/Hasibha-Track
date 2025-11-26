import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';


class OtpInputField extends StatefulWidget {
  final Function() onCompleted;
  final TextEditingController otpController;

  const OtpInputField(
      {super.key, required this.onCompleted, required this.otpController});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.otpController,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        widget.onCompleted();
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
        widget.onCompleted();
      },
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 8,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: AppStrings.enterOtp,
        labelStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.greyLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        counterStyle: GoogleFonts.poppins(fontSize: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.errorEnterOtp;
        } else if (value.length != 6) {
          return AppStrings.errorOtpLength;
        }
        return null;
      },
    );
  }
}
