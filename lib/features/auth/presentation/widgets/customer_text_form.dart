import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/const/colors.dart';

class CustomerTextForm extends StatefulWidget {
  final String name;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function()? onFieldSubmitted;
  final TextInputType? keyboardType;
  
  const CustomerTextForm({
    required this.name,
    required this.controller,
    this.isPassword = false,
    this.validator,
    super.key,
    this.onFieldSubmitted,
    this.keyboardType,
  });

  @override
  _CustomerTextFormState createState() => _CustomerTextFormState();
}

class _CustomerTextFormState extends State<CustomerTextForm> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
        widget.onFieldSubmitted?.call();
      },
      onEditingComplete:(){
        FocusScope.of(context).unfocus();
        widget.onFieldSubmitted?.call();
      },
      controller: widget.controller,
      obscureText: widget.isPassword && !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      cursorColor: AppColors.primary,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: widget.name,
        labelStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.greyLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        errorStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.error,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
