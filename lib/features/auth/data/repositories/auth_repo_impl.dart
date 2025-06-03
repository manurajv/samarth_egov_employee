import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> login(String employeeId, String password) async {
    try {
      final token = await remoteDataSource.login(employeeId, password);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset(String emailOrId) async {
    try {
      await remoteDataSource.sendPasswordReset(emailOrId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}