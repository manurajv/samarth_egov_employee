// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../repositories/auth_repo.dart';
//
// class OTPUsecase {
//   final AuthRepository repository;
//
//   OTPUsecase(this.repository);
//
//   Future<Either<Failure, Map<String, String>>> getUniversities() async { // Updated return type
//     return await repository.getUniversities();
//   }
//
//   Future<Either<Failure, String>> sendOTP(String email, String organization) async {
//     return await repository.sendOTP(email, organization);
//   }
//
//   Future<Either<Failure, String>> verifyOTP(
//       String verificationId,
//       String otp,
//       String email,
//       String organization,
//       ) async {
//     return await repository.verifyOTP(verificationId, otp, email, organization);
//   }
// }