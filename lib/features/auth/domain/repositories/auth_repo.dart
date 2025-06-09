import '../../data/models/login_response.dart';

abstract class AuthRepository {
  Future<Map<String, String>> getUniversities();
  Future<AuthResponse> sendSignInLink(String email, String organizationSlug);
  Future<AuthResponse> verifySignInLink(String email, String organizationSlug);
}