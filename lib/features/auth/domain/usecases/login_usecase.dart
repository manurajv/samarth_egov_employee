import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repo.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, String>> execute(
      String employeeId, String password) async {
    return await repository.login(employeeId, password);
  }
}