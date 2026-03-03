import 'package:equatable/equatable.dart';

abstract class SmsEvent extends Equatable {
  const SmsEvent();

  @override
  List<Object?> get props => [];
}

class SendSmsRequested extends SmsEvent {
  final String phone;

  const SendSmsRequested({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class VerifySmsRequested extends SmsEvent {
  final String phone;
  final String code;

  const VerifySmsRequested({required this.phone, required this.code});

  @override
  List<Object?> get props => [phone, code];
}

class SmsReset extends SmsEvent {}
