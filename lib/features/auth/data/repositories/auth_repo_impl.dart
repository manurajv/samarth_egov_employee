import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, String>>> getUniversities() async { // Updated return type
    try {
      final universities = await remoteDataSource.getUniversities();
      return Right(universities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendOTP(String email, String organization) async {
    try {
      final verificationId = await remoteDataSource.sendOTP(email, organization);
      return Right(verificationId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOTP(
      String verificationId,
      String otp,
      String email,
      String organization,
      ) async {
    try {
      final token = await remoteDataSource.verifyOTP(verificationId, otp, email, organization);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}