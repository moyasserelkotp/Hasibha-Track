import 'package:dio/dio.dart';
import '../dtos/user_profile_dto.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileDto> getUserProfile();
  Future<UserProfileDto> updateProfile(UpdateProfileDto dto);
  Future<String> uploadProfilePhoto(String filePath);
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  static const String baseUrl = '/api/profile';

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileDto> getUserProfile() async {
    try {
      final response = await dio.get(baseUrl);
      return UserProfileDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  @override
  Future<UserProfileDto> updateProfile(UpdateProfileDto dto) async {
    try {
      final response = await dio.put(
        baseUrl,
        data: dto.toJson(),
      );
      return UserProfileDto.fromJson(response.data['data'] ?? response.data);
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
        '$baseUrl/photo',
        data: formData,
      );
      
      return response.data['photoUrl'] ?? response.data['data']['photoUrl'];
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await dio.delete(baseUrl);
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
