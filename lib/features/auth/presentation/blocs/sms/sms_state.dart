import 'package:equatable/equatable.dart';

abstract class SmsState extends Equatable {
  const SmsState();

  @override
  List<Object?> get props => [];
}

class SmsInitial extends SmsState {
  const SmsInitial();
}

class SmsLoading extends SmsState {
  const SmsLoading();
}

class SmsCodeSent extends SmsState {
  final String message;
  const SmsCodeSent(this.message);

  @override
  List<Object?> get props => [message];
}

class SmsVerified extends SmsState {
  final String phoneVerificationToken;
  const SmsVerified(this.phoneVerificationToken);

  @override
  List<Object?> get props => [phoneVerificationToken];
}

class SmsFailure extends SmsState {
  final String errorMessage;
  final int? secondsLeft;

  const SmsFailure(this.errorMessage, {this.secondsLeft});

  @override
  List<Object?> get props => [errorMessage, secondsLeft];
}
