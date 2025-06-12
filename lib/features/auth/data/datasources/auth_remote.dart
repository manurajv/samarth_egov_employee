import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/email_service.dart';
import '../models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, String>> getUniversities();
  Future<AuthResponse> sendSignInLink(String email, String organizationSlug);
  Future<bool> verifySignInLink(String email, String organizationSlug, String token);
  Future<List<Map<String, dynamic>>> getUsers(String organizationSlug, String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final EmailService emailService;

  AuthRemoteDataSourceImpl({required this.dioClient, required this.emailService});

  static const Map<String, List<String>> _validDomains = {
    'delhi-university': ['iic.ac.in', 'du.ac.in'],
    'jnu': ['jnu.ac.in'],
  };

  @override
  Future<Map<String, String>> getUniversities() async {
    try {
      final response = await dioClient.dio.get('https://user1749627892472.requestly.tech/universities');
      if (response.statusCode == 200) {
        if (response.data is List<dynamic>) {
          final List<dynamic> universities = response.data;
          final Map<String, String> universityMap = {};
          for (var university in universities) {
            universityMap[university['name'] as String] = university['slug'] as String;
          }
          return universityMap;
        }
        print('Invalid response type: ${response.data.runtimeType}');
        throw Exception('Invalid response format: Expected a list of universities');
      }
      throw Exception('Failed to fetch universities: ${response.statusCode}');
    } catch (e) {
      print('AuthRemoteDataSourceImpl.getUniversities error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthResponse> sendSignInLink(String email, String organizationSlug) async {
    try {
      final emailDomain = email.split('@').last.toLowerCase();
      final validDomains = _validDomains[organizationSlug] ?? [];
      if (!validDomains.contains(emailDomain)) {
        throw Exception('Email domain does not match the selected organization');
      }

      final userResponse = await dioClient.dio.get(
        'https://user1749627892472.requestly.tech/$organizationSlug/users',
        queryParameters: {'email': email},
      );

      if (userResponse.statusCode != 200 || userResponse.data.isEmpty) {
        throw Exception('User not found in this organization');
      }

      await emailService.sendVerificationEmail(email, organizationSlug);

      return const AuthResponse(
        token: '',
        message: 'Link sent successfully',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('User not found in this organization');
      }
      throw Exception('Failed to send sign-in link: ${e.message}');
    }
  }

  @override
  Future<bool> verifySignInLink(String email, String organizationSlug, String token) async {
    try {
      final isValid = await emailService.verifyToken(email, token, organizationSlug);
      if (!isValid) {
        throw Exception('Invalid or expired verification link');
      }
      return isValid;
    } catch (e) {
      print('AuthRemoteDataSourceImpl.verifySignInLink error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers(String organizationSlug, String email) async {
    try {
      final response = await dioClient.dio.get(
        'https://user1749627892472.requestly.tech/$organizationSlug/users',
        queryParameters: {'email': email},
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      throw Exception('Failed to fetch users: ${response.statusCode}');
    } catch (e) {
      print('AuthRemoteDataSourceImpl.getUsers error: $e');
      rethrow;
    }
  }
}