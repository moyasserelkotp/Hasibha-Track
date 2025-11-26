import 'package:equatable/equatable.dart';



class Register extends Equatable {

  final String? status;
  final String? message;
  final Data? data;
  
  Register({
    required this.status,
    required this.message,
    required this.data,
  });
  

  @override
  List<Object?> get props => [
    status, message, data, ];
}

class Data extends Equatable {

  final int? id;
  final String? username;
  final String? email;
  final String? mobile;
  final String? fullName;
  final dynamic bio;
  final dynamic location;
  final dynamic birthDate;
  final dynamic avatar;
  final dynamic backgroundImage;
  final String? message;
  final Tokens? tokens;
  
  
  Data({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.fullName,
    required this.bio,
    required this.location,
    required this.birthDate,
    required this.avatar,
    required this.backgroundImage,
    required this.message,
    required this.tokens,
  });
  

  @override
  List<Object?> get props => [
    id, username, email, mobile, fullName, bio, location, birthDate, avatar, backgroundImage, message, tokens, ];
}

class Tokens extends Equatable {

  final String? refresh;
  final String? access;
  
  Tokens({
    required this.refresh,
    required this.access,
  });
  
  @override
  List<Object?> get props => [
    refresh, access, ];
}
