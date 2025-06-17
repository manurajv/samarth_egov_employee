import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/login_response.dart';
import '../repositories/auth_repo.dart';

class AuthUseCase {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;
  final SharedPreferences _prefs;

  AuthUseCase(this._authRepository, {FlutterSecureStorage? storage, required SharedPreferences prefs})
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
    return await _authRepository.getUsers(organizationSlug, email);
  }

  Future<void> storeUserSession({
    required String id,
    required String email,
    required String name,
    required String organizationSlug,
  }) async {
    await _storage.write(key: 'auth_token', value: 'mock_token'); // Replace with actual token from verifySignInLink
    await _prefs.setString('orgSlug', organizationSlug);
    await _prefs.setString('employeeName', name);
    await _prefs.setString('userId', id);
    await _prefs.setString('email', email);
  }
}