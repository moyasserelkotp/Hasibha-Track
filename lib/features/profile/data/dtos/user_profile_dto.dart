class UserProfileDto {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final String? bio;
  final Map<String, dynamic>? statistics;
  final Map<String, dynamic>? preferences;
  final String createdAt;
  final String updatedAt;

  UserProfileDto({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.bio,
    this.statistics,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      statistics: json['statistics'],
      preferences: json['preferences'],
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'bio': bio,
      'statistics': statistics,
      'preferences': preferences,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class UpdateProfileDto {
  final String? name;
  final String? phoneNumber;
  final String? bio;
  final String? photoUrl;

  UpdateProfileDto({
    this.name,
    this.phoneNumber,
    this.bio,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (bio != null) map['bio'] = bio;
    if (photoUrl != null) map['photoUrl'] = photoUrl;
    return map;
  }
}
