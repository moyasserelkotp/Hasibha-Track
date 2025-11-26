import 'package:equatable/equatable.dart';

class ErrorServerModel extends Equatable {
  final int statusCode;
  final String statusMessage;
  final bool success;

  const ErrorServerModel(
      {required this.statusCode,
      required this.statusMessage,
      required this.success});

  factory ErrorServerModel.fromJson(Map<String, dynamic> json) {
    return ErrorServerModel(
      statusCode: json["statusCode"],
      statusMessage: json["statusMessage"],
      success: json["success"],
    );
  }

  @override
  List<Object?> get props => [
        statusMessage,
        statusCode,
        success,
      ];
}
