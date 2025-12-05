/// Form validation logic for authentication
/// Separates validation from UI logic
class AuthValidators {
  // Private constructor to prevent instantiation
  AuthValidators._();

  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (value.length > 30) {
      return 'Username must not exceed 30 characters';
    }
    
    // Username should contain only alphanumeric and underscore
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null;
  }

  /// Identifier validation (email or phone)
  static String? validateIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or phone is required';
    }
    
    // Check if it looks like an email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    // Check if it looks like a phone number (with or without +)
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    
    if (emailRegex.hasMatch(value) || phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return null;
    }
    
    return 'Please enter a valid email or phone number';
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (value.length > 128) {
      return 'Password must not exceed 128 characters';
    }
    
    // Optional: Enforce password strength
    // Uncomment these checks if you want stronger passwords
    /*
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    */
    
    return null;
  }

  /// Confirm password validation
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// OTP validation
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    // OTP should be 6 digits (adjust based on your backend)
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    // OTP should contain only numbers
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }

  /// Full name validation
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    
    if (value.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    
    if (value.length > 100) {
      return 'Full name must not exceed 100 characters';
    }
    
    // Name should contain only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Full name should contain only letters and spaces';
    }
    
    return null;
  }

  /// Mobile number validation (optional field)
  static String? validateMobile(String? value) {
    // Mobile is optional, so null or empty is valid
    if (value == null || value.isEmpty) {
      return null;
    }
    
    // Remove any spaces or dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    
    // Mobile should be 10-15 digits (adjust based on your requirements)
    if (cleanNumber.length < 10 || cleanNumber.length > 15) {
      return 'Mobile number should be 10-15 digits';
    }
    
    // Should contain only numbers and optional + prefix
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(cleanNumber)) {
      return 'Please enter a valid mobile number';
    }
    
    return null;
  }

  /// Generic required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
