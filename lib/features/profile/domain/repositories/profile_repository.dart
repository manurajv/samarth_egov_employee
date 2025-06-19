import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String email, String organizationSlug);
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity profile);
}