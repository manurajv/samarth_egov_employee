import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Either<Failure, ProfileEntity>> call() async {
    return await repository.getProfile();
  }
}