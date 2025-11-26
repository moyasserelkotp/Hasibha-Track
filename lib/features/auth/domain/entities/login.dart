import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final String? refresh;
  final String? access;
  final UserInfo? userInfo;

  const Login({
    required this.refresh,
    required this.access,
    required this.userInfo,
  });
  
  @override
  List<Object?> get props => [
        refresh,
        access,
        userInfo,
      ];
}
class UserInfo extends Equatable {
  final int? id;
  final String? username;
  final String? email;
  final String? fullName;
  final String? mobile;
  final Profile? profile;
  final String? avatar;
  final int? totalPosts;
  final int? followers;
  final int? following;
  final int? totalLikes;

  const UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.mobile,
    required this.profile,
    required this.avatar,
    required this.totalPosts,
    required this.followers,
    required this.following,
    required this.totalLikes,
  });
  
  @override
  List<Object?> get props => [
        id,
        username,
        email,
        fullName,
        mobile,
        profile,
        avatar,
        totalPosts,
        followers,
        following,
        totalLikes,
      ];
}
class Profile extends Equatable {
  final dynamic bio;
  final bool? isPrivate;
  final bool? verified;
  final bool? isBusiness;
  final bool? isSuspended;

  const Profile({
    required this.bio,
    required this.isPrivate,
    required this.verified,
    required this.isBusiness,
    required this.isSuspended,
  });
  

  @override
  List<Object?> get props => [
        bio,
        isPrivate,
        verified,
        isBusiness,
        isSuspended,
      ];
}

