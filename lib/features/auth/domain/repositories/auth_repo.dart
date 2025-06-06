import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, String>>> getUniversities(); // Updated return type
  Future<Either<Failure, String>> sendOTP(String email, String organization);
  Future<Either<Failure, String>> verifyOTP(
      String verificationId, String otp, String email, String organization);
}