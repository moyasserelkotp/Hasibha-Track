import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_result.dart';

/// States for login functionality
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Login in progress
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Login successful
class LoginSuccess extends LoginState {
  final AuthResult authResult;

  const LoginSuccess(this.authResult);

  @override
  List<Object?> get props => [authResult];
}

/// Login failed
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
