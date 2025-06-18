import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/login_response.dart';
import '../repositories/auth_repo.dart';

class AuthUseCase {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;
  final SharedPreferences _prefs;
  final DioClient _dioClient;

  AuthUseCase(
      this._authRepository,
      this._dioClient,
      {FlutterSecureStorage? storage, required SharedPreferences prefs})
      : _storage = storage ?? const FlutterSecureStorage(),
        _prefs = prefs;

  Future<Map<String, String>> getUniversities() async {
    return await _authRepository.getUniversities();
  }

  Future<AuthResponse> sendSignInLink(String email, String organizationSlug) async {
    return await _authRepository.sendSignInLink(email, organizationSlug);
  }

  Future<bool> verifySignInLink(String email, String organizationSlug, String token) async {
    return await _authRepository.verifySignInLink(email, organizationSlug, token);
  }

  Future<List<Map<String, dynamic>>> getUsers(String organizationSlug, String email) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.baseUrl}/$organizationSlug/users',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        // Handle both array and single object responses
        if (response.data is List) {
          final users = List<Map<String, dynamic>>.from(response.data);
          // Additional client-side filtering as fallback
          return users.where((user) => user['email'] == email).toList();
        } else if (response.data is Map) {
          final user = Map<String, dynamic>.from(response.data);
          // Verify the returned user matches the requested email
          if (user['email'] == email) {
            return [user];
          }
          return [];
        }
        return [];
      }
      throw Exception('Failed to fetch users: ${response.statusCode}');
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  Future<void> storeUserSession({
    required String id,
    required String email,
    required String name,
    required String organizationSlug,
  }) async {
    // Store in secure storage
    await _storage.write(key: 'auth_token', value: 'mock_token'); // Replace with actual token
    await _storage.write(key: 'user_id', value: id);
    await _storage.write(key: 'user_email', value: email);

    // Store in shared prefs for quick access
    await _prefs.setString('orgSlug', organizationSlug);
    await _prefs.setString('employeeName', name);
    await _prefs.setString('userId', id);
    await _prefs.setString('email', email);
  }
}