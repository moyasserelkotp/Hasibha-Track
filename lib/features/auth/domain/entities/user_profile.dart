import 'package:equatable/equatable.dart';

/// User profile entity containing profile-specific information
class UserProfile extends Equatable {
  final String? bio;
  final bool isPrivate;
  final bool verified;
  final bool isBusiness;
  final bool isSuspended;

  const UserProfile({
    this.bio,
    this.isPrivate = false,
    this.verified = false,
    this.isBusiness = false,
    this.isSuspended = false,
  });

  @override
  List<Object?> get props => [
        bio,
        isPrivate,
        verified,
        isBusiness,
        isSuspended,
      ];

  /// Check if user can access the account
  bool get canAccess => !isSuspended;

  /// Get bio or default message
  String get bioOrDefault => bio ?? 'No bio available';
}
