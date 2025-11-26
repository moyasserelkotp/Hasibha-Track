import '../../domain/entities/user_profile.dart';

/// User profile model - handles API serialization
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    super.bio,
    super.isPrivate,
    super.verified,
    super.isBusiness,
    super.isSuspended,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      bio: json['bio'],
      isPrivate: json['is_private'] ?? false,
      verified: json['verified'] ?? false,
      isBusiness: json['is_business'] ?? false,
      isSuspended: json['is_suspended'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'is_private': isPrivate,
      'verified': verified,
      'is_business': isBusiness,
      'is_suspended': isSuspended,
    };
  }

  /// Convert model to entity
  UserProfile toEntity() {
    return UserProfile(
      bio: bio,
      isPrivate: isPrivate,
      verified: verified,
      isBusiness: isBusiness,
      isSuspended: isSuspended,
    );
  }
}
