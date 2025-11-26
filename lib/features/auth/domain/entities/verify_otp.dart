import 'package:equatable/equatable.dart';

class VerifyOtp extends Equatable {

  final String? message;
  final User? user;
  
  const VerifyOtp({
    required this.message,
    required this.user,
  });
  

  @override
  List<Object?> get props => [
    message, user, ];
}

class User extends Equatable {

  final String? email;
  final bool? isEmailVerified;
  
  const User({
    required this.email,
    required this.isEmailVerified,
  });
  

  @override
  List<Object?> get props => [
    email, isEmailVerified, ];
}
