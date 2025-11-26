import '../../domain/entities/user.dart';
import 'user_profile_model.dart';

/// User model - handles API serialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.fullName,
    super.mobile,
    super.profile,
    super.avatar,
    super.totalPosts,
    super.followers,
    super.following,
    super.totalLikes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String? ?? '',
      mobile: json['mobile'] as String?,
      profile: json['profile'] != null
          ? UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      avatar: json['avatar'] as String?,
      totalPosts: json['total_posts'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      totalLikes: json['total_likes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      if (mobile != null) 'mobile': mobile,
      if (profile != null)
        'profile': (profile as UserProfileModel).toJson(),
      if (avatar != null) 'avatar': avatar,
      'total_posts': totalPosts,
      'followers': followers,
      'following': following,
      'total_likes': totalLikes,
    };
  }

  /// Convert model to entity
  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      fullName: fullName,
      mobile: mobile,
      profile: profile != null
          ? (profile as UserProfileModel).toEntity()
          : null,
      avatar: avatar,
      totalPosts: totalPosts,
      followers: followers,
      following: following,
      totalLikes: totalLikes,
    );
  }
}
