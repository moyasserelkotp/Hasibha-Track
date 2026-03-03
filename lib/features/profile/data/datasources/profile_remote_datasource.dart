import 'package:dio/dio.dart';
import 'package:hasibha/core/network/app_env.dart';
import '../dtos/user_profile_dto.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileDto> getUserProfile();
  Future<UserProfileDto> updateProfile(UpdateProfileDto dto);
  Future<String> uploadProfilePhoto(String filePath);
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  String get _profileUrl => '${AppEnv.homeBaseUrl}/api/profile';

  @override
  Future<UserProfileDto> getUserProfile() async {
    try {
      // GET http://localhost:5001/api/profile
      final response = await dio.get(_profileUrl);
      return UserProfileDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  @override
  Future<UserProfileDto> updateProfile(UpdateProfileDto dto) async {
    try {
      // PUT http://localhost:5001/api/profile
      // Response: { message, profile: { ... } }
      final response = await dio.put(
        _profileUrl,
        data: dto.toJson(),
      );
      final data = response.data as Map<String, dynamic>;
      final profileJson =
          (data['profile'] ?? data) as Map<String, dynamic>;
      return UserProfileDto.fromJson(profileJson);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<String> uploadProfilePhoto(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });
      
      final response = await dio.post(
        '$_profileUrl/photo',
        data: formData,
      );
      
      final data = response.data as Map<String, dynamic>;
      return (data['photoUrl'] ??
              (data['profile'] != null
                  ? (data['profile'] as Map<String, dynamic>)['photoUrl']
                  : null)) as String;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await dio.delete(_profileUrl);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}

// Mock implementation
class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  UserProfileDto? _cachedProfile;

  @override
  Future<UserProfileDto> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _cachedProfile ??= UserProfileDto(
      id: 'mock-user-id',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+1234567890',
      photoUrl: null,
      bio: 'Smart budgeting enthusiast',
      statistics: {
        'totalTransactions': 156,
        'daysActive': 45,
        'totalBudgets': 5,
        'totalSavingsGoals': 3,
      },
      preferences: {
        'currency': 'USD',
        'theme': 'system',
        'notifications': true,
      },
      createdAt: DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    
    return _cachedProfile!;
  }

  @override
  Future<UserProfileDto> updateProfile(UpdateProfileDto dto) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_cachedProfile == null) {
      await getUserProfile();
    }
    
    _cachedProfile = UserProfileDto(
      id: _cachedProfile!.id,
      name: dto.name ?? _cachedProfile!.name,
      email: _cachedProfile!.email,
      phoneNumber: dto.phoneNumber ?? _cachedProfile!.phoneNumber,
      photoUrl: dto.photoUrl ?? _cachedProfile!.photoUrl,
      bio: dto.bio ?? _cachedProfile!.bio,
      statistics: _cachedProfile!.statistics,
      preferences: _cachedProfile!.preferences,
      createdAt: _cachedProfile!.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
    
    return _cachedProfile!;
  }

  @override
  Future<String> uploadProfilePhoto(String filePath) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'https://ui-avatars.com/api/?name=${_cachedProfile?.name ?? 'User'}&size=200';
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _cachedProfile = null;
  }
}
