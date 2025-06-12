import '../../data/models/login_response.dart';
import '../repositories/auth_repo.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

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
    await _authRepository.storeUserSession(
      id: id,
      email: email,
      name: name,
      organizationSlug: organizationSlug,
    );
  }
}