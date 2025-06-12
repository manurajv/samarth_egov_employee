import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/auth_remote.dart';
import '../../data/models/login_response.dart';

abstract class AuthRepository {
  Future<Map<String, String>> getUniversities();
  Future<AuthResponse> sendSignInLink(String email, String organizationSlug);
  Future<bool> verifySignInLink(String email, String organizationSlug, String token);
  Future<List<Map<String, dynamic>>> getUsers(String organizationSlug, String email);
  Future<void> storeUserSession({
    required String id,
    required String email,
    required String name,
    required String organizationSlug,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, String>> getUniversities() async {
    return await _remoteDataSource.getUniversities();
  }

  @override
  Future<AuthResponse> sendSignInLink(String email, String organizationSlug) async {
    return await _remoteDataSource.sendSignInLink(email, organizationSlug);
  }

  @override
  Future<bool> verifySignInLink(String email, String organizationSlug, String token) async {
    return await _remoteDataSource.verifySignInLink(email, organizationSlug, token);
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers(String organizationSlug, String email) async {
    return await _remoteDataSource.getUsers(organizationSlug, email);
  }

  @override
  Future<void> storeUserSession({
    required String id,
    required String email,
    required String name,
    required String organizationSlug,
  }) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'user_id', value: id);
    await storage.write(key: 'user_email', value: email);
    await storage.write(key: 'user_name', value: name);
    await storage.write(key: 'organization_slug', value: organizationSlug);
  }
}