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

/// Registration successful - user is now authenticated
class RegisterSuccess extends RegisterState {
  final AuthResult authResult;

  const RegisterSuccess(this.authResult);

  @override
  List<Object?> get props => [authResult];
}

/// Registration failed
class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}
