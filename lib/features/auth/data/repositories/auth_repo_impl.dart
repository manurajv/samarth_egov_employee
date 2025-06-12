// import '../datasources/auth_remote.dart';
// import '../models/login_response.dart';
// import '../../domain/repositories/auth_repo.dart';
//
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//
//   AuthRepositoryImpl(this.remoteDataSource);
//
//   @override
//   Future<Map<String, String>> getUniversities() async {
//     return await remoteDataSource.getUniversities();
//   }
//
//   @override
//   Future<AuthResponse> sendSignInLink(String email, String organizationSlug) async {
//     return await remoteDataSource.sendSignInLink(email, organizationSlug);
//   }
//
//   @override
//   Future<AuthResponse> verifySignInLink(String email, String organizationSlug, String? token) async {
//     return await remoteDataSource.verifySignInLink(email, organizationSlug, token);
//   }
// }