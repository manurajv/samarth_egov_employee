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
      print('Dio Request: GET ${dioClient.dio.options.baseUrl}/universities');
      final response = await dioClient.dio.get('/universities');
      print('Dio Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> universities = response.data;
        return await compute(_parseUniversities, universities);
      } else {
        throw Exception('Failed to fetch universities: ${response.statusCode}');
      }
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
      print('Dio Request: POST ${dioClient.dio.options.baseUrl}/$organizationSlug/auth/send-link');
      final response = await dioClient.dio.post(
        '/$organizationSlug/auth/send-link',
        data: {'email': email},
      );
      print('Dio Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        return AuthResponse(
          token: response.data['token'] ?? '',
          message: response.data['message'] ?? 'Link sent successfully',
        );
      } else {
        throw Exception('Failed to send sign-in link: ${response.statusCode}');
      }
    } catch (e) {
      print('AuthRemoteDataSourceImpl.sendSignInLink error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthResponse> verifySignInLink(String email, String organizationSlug) async {
    try {
      print('Dio Request: POST ${dioClient.dio.options.baseUrl}/$organizationSlug/auth/verify-link');
      final response = await dioClient.dio.post(
        '/$organizationSlug/auth/verify-link',
        data: {'email': email},
      );
      print('Dio Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        return AuthResponse(
          token: response.data['token'] ?? '',
          message: response.data['message'] ?? 'Verification successful',
        );
      } else {
        throw Exception('Failed to verify sign-in link: ${response.statusCode}');
      }
    } catch (e) {
      print('AuthRemoteDataSourceImpl.verifySignInLink error: $e');
      rethrow;
    }
  }
}