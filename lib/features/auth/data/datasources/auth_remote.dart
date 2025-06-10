// auth_remote.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, String>> getUniversities();
  Future<AuthResponse> sendSignInLink(String email, String organizationSlug);
  Future<AuthResponse> verifySignInLink(String email, String organizationSlug);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, String>> getUniversities() async {
    try {
      final response = await dioClient.dio.get('/universities');
      if (response.statusCode == 200) {
        final List<dynamic> universities = response.data;
        return await compute(_parseUniversities, universities);
      }
      throw Exception('Failed to fetch universities: ${response.statusCode}');
    } catch (e) {
      print('AuthRemoteDataSourceImpl.getUniversities error: $e');
      rethrow;
    }
  }

  static Map<String, String> _parseUniversities(List<dynamic> universities) {
    final Map<String, String> universityMap = {};
    for (var university in universities) {
      universityMap[university['name'] as String] = university['slug'] as String;
    }
    return universityMap;
  }

  @override
  Future<AuthResponse> sendSignInLink(String email, String organizationSlug) async {
    try {
      // First verify user belongs to organization
      final userResponse = await dioClient.dio.get(
        '/$organizationSlug/users',
        queryParameters: {'email': email},
      );

      if (userResponse.statusCode != 200 || userResponse.data.isEmpty) {
        throw Exception('User not found in this organization');
      }

      // If user exists, send the link
      final response = await dioClient.dio.post(
        '/$organizationSlug/auth/send-link',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return AuthResponse(
          token: response.data['token'] ?? '',
          message: response.data['message'] ?? 'Link sent successfully',
        );
      }
      throw Exception('Failed to send sign-in link: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('User not found in this organization');
      }
      throw Exception('Failed to send sign-in link: ${e.message}');
    }
  }

  @override
  Future<AuthResponse> verifySignInLink(String email, String organizationSlug) async {
    try {
      final response = await dioClient.dio.post(
        '/$organizationSlug/auth/verify-link',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return AuthResponse(
          token: response.data['token'] ?? '',
          message: response.data['message'] ?? 'Verification successful',
        );
      }
      throw Exception('Failed to verify sign-in link: ${response.statusCode}');
    } catch (e) {
      print('AuthRemoteDataSourceImpl.verifySignInLink error: $e');
      rethrow;
    }
  }
}