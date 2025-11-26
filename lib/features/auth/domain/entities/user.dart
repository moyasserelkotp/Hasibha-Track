import 'package:equatable/equatable.dart';
import 'user_profile.dart';

/// Core User entity representing an authenticated user
class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String? mobile;
  final UserProfile? profile;
  final String? avatar;
  final int totalPosts;
  final int followers;
  final int following;
  final int totalLikes;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.mobile,
    this.profile,
    this.avatar,
    this.totalPosts = 0,
    this.followers = 0,
    this.following = 0,
    this.totalLikes = 0,
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

  /// Get display name (full name or username)
  String get displayName => fullName.isNotEmpty ? fullName : username;

  /// Check if user has avatar
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  /// Check if user is verified
  bool get isVerified => profile?.verified ?? false;

  /// Check if profile is complete
  bool get isProfileComplete =>
      fullName.isNotEmpty && email.isNotEmpty && mobile != null;
}
