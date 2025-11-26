import '../../../domain/entities/register.dart';

class RegisterModel extends Register {
  RegisterModel(
      {required super.status,
      required super.message,
      required super.data});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? null
          : DataModel.fromJson(json["data"]),
    );
  }
}

class DataModel extends Data {
  DataModel(
      {required super.id,
      required super.username,
      required super.email,
      required super.mobile,
      required super.fullName,
      required super.bio,
      required super.location,
      required super.birthDate,
      required super.avatar,
      required super.backgroundImage,
      required super.message,
      required super.tokens});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      mobile: json["mobile"],
      fullName: json["full_name"],
      bio: json["bio"],
      location: json["location"],
      birthDate: json["birth_date"],
      avatar: json["avatar"],
      backgroundImage: json["background_image"],
      message: json["message"],
      tokens: json["tokens"] == null
          ? null
          : TokensModel.fromJson(json["tokens"]),
    );
  }
}

class TokensModel extends Tokens {
  TokensModel({required super.refresh, required super.access});

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      refresh: json["refresh"],
      access: json["access"],
    );
  }
}
