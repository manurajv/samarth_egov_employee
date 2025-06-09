import '../../data/models/login_response.dart';
import '../repositories/auth_repo.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<Map<String, String>> getUniversities() async {
    return await repository.getUniversities();
  }

  Future<AuthResponse> sendSignInLink(String email, String organizationSlug) async {
    return await repository.sendSignInLink(email, organizationSlug);
  }

  Future<AuthResponse> verifySignInLink(String email, String organizationSlug) async {
    return await repository.verifySignInLink(email, organizationSlug);
  }
}