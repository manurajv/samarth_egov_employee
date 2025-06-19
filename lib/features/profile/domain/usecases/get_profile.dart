import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;
  final SharedPreferences prefs;
  final FlutterSecureStorage storage;

  GetProfile(this.repository, {required this.prefs, required this.storage});

  Future<Either<Failure, ProfileEntity>> call() async {
    final authToken = await storage.read(key: 'auth_token');
    if (authToken == null || authToken.isEmpty) {
      print('GetProfile: Missing auth_token');
      return Left(AuthenticationFailure('Unauthorized'));
    }
    final organizationSlug = prefs.getString('orgSlug') ?? '';
    final email = await storage.read(key: 'user_email') ?? '';
    print('GetProfile: Using organizationSlug: $organizationSlug, email: $email');
    if (organizationSlug.isEmpty || email.isEmpty) {
      print('GetProfile: Missing organizationSlug or email');
      return Left(CacheFailure());
    }
    return await repository.getProfile(email, organizationSlug);
  }
}