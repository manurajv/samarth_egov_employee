import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/error/failures.dart';
import '../models/profile_model.dart';

class ServerException implements Exception {
  final String message;
  final String statusCode;

  ServerException({required this.message, required this.statusCode});
}

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String email, String organizationSlug);
  Future<void> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProfileModel> getProfile(String email, String organizationSlug) async {
    try {
      final response = await dio.get(
        'https://user1749627892472.requestly.tech/$organizationSlug/employee/profile',
        queryParameters: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': await _getAuthHeader(),
          },
        ),
      );
      print('ProfileRemoteDataSource: Response status: ${response.statusCode}, data: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: '200',
          );
        }
        if (response.data is List<dynamic>) {
          final profiles = response.data as List<dynamic>;
          final matchingProfile = profiles.firstWhere(
                (profile) => profile['profile']['email'] == email,
            orElse: () => throw ServerException(
              message: 'No profile found for email: $email',
              statusCode: '404',
            ),
          );
          final profileModel = ProfileModel.fromJson(matchingProfile);
          print('ProfileRemoteDataSource: Parsed ProfileModel: ${profileModel.fullName}');
          return profileModel;
        } else if (response.data is Map<String, dynamic>) {
          final profileModel = ProfileModel.fromJson(response.data);
          if (profileModel.email != email) {
            throw ServerException(
              message: 'Profile email does not match requested email',
              statusCode: '400',
            );
          }
          print('ProfileRemoteDataSource: Parsed ProfileModel: ${profileModel.fullName}');
          return profileModel;
        } else {
          throw ServerException(
            message: 'Unexpected response format',
            statusCode: '500',
          );
        }
      }
      throw ServerException(
        message: 'Failed to fetch profile: ${response.statusMessage}',
        statusCode: response.statusCode.toString(),
      );
    } catch (e) {
      print('ProfileRemoteDataSource: Error fetching profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      final response = await dio.put(
        'https://user1749627892472.requestly.tech/${profile.department.toLowerCase()}/employee/profile',
        data: profile.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': await _getAuthHeader(),
          },
        ),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to update profile: ${response.statusMessage}',
          statusCode: response.statusCode.toString(),
        );
      }
    } catch (e) {
      print('ProfileRemoteDataSource: Error updating profile: $e');
      rethrow;
    }
  }

  Future<String> _getAuthHeader() async {
    final storage = await FlutterSecureStorage();
    final authToken = await storage.read(key: 'auth_token');
    return authToken != null ? 'Bearer $authToken' : '';
  }
}