import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String employeeId, String password);
  Future<Either<Failure, void>> sendPasswordReset(String emailOrId);
}