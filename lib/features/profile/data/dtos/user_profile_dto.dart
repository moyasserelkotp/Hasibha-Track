class UserProfileDto {
  final String id;
  final String userId;
  final String displayName;
  final String? profilePhoto;
  final String currency;
  final String createdAt;
  final String updatedAt;

  UserProfileDto({
    required this.id,
    required this.userId,
    required this.displayName,
    this.profilePhoto,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      userId: (json['userId'] ?? '') as String,
      displayName: (json['displayName'] ?? json['name'] ?? '') as String,
      profilePhoto: (json['profilePhoto'] ?? json['photoUrl']) as String?,
      currency: (json['currency'] ?? 'USD') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'displayName': displayName,
      'profilePhoto': profilePhoto,
      'currency': currency,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class UpdateProfileDto {
  final String? displayName;
  final String? profilePhoto;
  final String? currency;

  UpdateProfileDto({
    this.displayName,
    this.profilePhoto,
    this.currency,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (displayName != null) map['displayName'] = displayName;
    if (profilePhoto != null) map['profilePhoto'] = profilePhoto;
    if (currency != null) map['currency'] = currency;
    return map;
  }
}
