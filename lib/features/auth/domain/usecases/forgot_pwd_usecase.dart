import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repo.dart';

class ForgotPwdUsecase {
  final AuthRepository repository;

  ForgotPwdUsecase(this.repository);

  Future<Either<Failure, void>> execute(String emailOrId) async {
    return await repository.sendPasswordReset(emailOrId);
  }
}