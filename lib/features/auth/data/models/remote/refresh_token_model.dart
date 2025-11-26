import '../../../domain/entities/resfresh_token.dart';



class RefreshTokenModel extends RefreshToken {
  const RefreshTokenModel({required super.access, required super.refresh});

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      access: json["access"],
      refresh: json["refresh"],
    );
  }
}
