import '../../../domain/entities/login.dart';

class LoginModel extends Login {
  LoginModel(
      {required super.refresh,
      required super.access,
      required super.userInfo});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      refresh: json["refresh"],
      access: json["access"],
      userInfo: json["user_info"] == null
          ? null
          : UserInfoModel.fromJson(json["user_info"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "refresh": refresh,
      "access": access,
      "user_info": (userInfo as UserInfoModel?)?.toJson(),
    };
  }
}

class UserInfoModel extends UserInfo {
  UserInfoModel(
      {required super.id,
      required super.username,
      required super.email,
      required super.fullName,
      required super.mobile,
      required super.profile,
      required super.avatar,
      required super.totalPosts,
      required super.followers,
      required super.following,
      required super.totalLikes});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      fullName: json["full_name"],
      mobile: json["mobile"],
      profile: json["profile"] == null
          ? null
          : ProfileModel.fromJson(json["profile"]),
      avatar: json["avatar"],
      totalPosts: json["total_posts"],
      followers: json["followers"],
      following: json["following"],
      totalLikes: json["total_likes"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "full_name": fullName,
      "mobile": mobile,
      "profile": (profile as ProfileModel?)?.toJson(),
      "avatar": avatar,
      "total_posts": totalPosts,
      "followers": followers,
      "following": following,
      "total_likes": totalLikes,
    };
  }
}

class ProfileModel extends Profile {
  ProfileModel(
      {required super.bio,
      required super.isPrivate,
      required super.verified,
      required super.isBusiness,
      required super.isSuspended});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      bio: json["bio"],
      isPrivate: json["is_private"],
      verified: json["verified"],
      isBusiness: json["is_business"],
      isSuspended: json["is_suspended"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bio": bio,
      "is_private": isPrivate,
      "verified": verified,
      "is_business": isBusiness,
      "is_suspended": isSuspended,
    };
  }
}
