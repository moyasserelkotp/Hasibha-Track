import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_result.dart';

/// States for registration functionality
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

/// Registration in progress
class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

/// Registration successful (awaiting OTP verification)
class RegisterSuccess extends RegisterState {
  final String email;
  final String message;

  const RegisterSuccess({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];
}

/// Registration failed
class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// OTP verification in progress
class OtpVerifying extends RegisterState {
  const OtpVerifying();
}

/// OTP verified successfully
class OtpVerified extends RegisterState {
  final AuthResult authResult;

  const OtpVerified(this.authResult);

  @override
  List<Object?> get props => [authResult];
}

/// OTP resent successfully
class OtpResent extends RegisterState {
  final String message;

  const OtpResent(this.message);

  @override
  List<Object?> get props => [message];
}

/// OTP operation failed
class OtpFailure extends RegisterState {
  final String message;

  const OtpFailure(this.message);

  @override
  List<Object?> get props => [message];
}
