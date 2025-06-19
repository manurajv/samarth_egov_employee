import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/models/profile_model.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String email, String organizationSlug) async {
    if (await networkInfo.isConnected) {
      try {
        final profile = await remoteDataSource.getProfile(email, organizationSlug);
        print('ProfileRepository: Profile fetched: ${profile.fullName}');
        return Right(profile.toEntity());
      } catch (e) {
        print('ProfileRepository: Error: $e');
        return Left(ServerFailure('ProfileRepository: Update error: $e'));
      }
    } else {
      print('ProfileRepository: No network connection');
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity profile) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProfile(profile.toModel());
        return Right(unit);
      } catch (e) {
        print('ProfileRepository: Update error: $e');
        return Left(ServerFailure('ProfileRepository: Update error: $e'));
      }
    } else {
      print('ProfileRepository: No network connection');
      return Left(NetworkFailure());
    }
  }
}

extension on ProfileEntity {
  ProfileModel toModel() {
    return ProfileModel(
      email: email,
      employeeId: employeeId,
      fullName: fullName,
      designation: designation,
      department: department,
      dob: dob,
      gender: gender,
      bloodGroup: bloodGroup,
      category: category,
      religion: religion,
      aadharNumber: aadharNumber,
      joiningDate: joiningDate,
      currentPosting: currentPosting,
      employeeType: employeeType,
      payLevel: payLevel,
      currentBasicPay: currentBasicPay,
      maritalStatus: maritalStatus,
      spouseName: spouseName,
      children: children,
      fatherName: fatherName,
      motherName: motherName,
      presentAddress: presentAddress,
      permanentAddress: permanentAddress,
      emergencyContact: emergencyContact,
      bankName: bankName,
      accountNumber: accountNumber,
      accountType: accountType,
      branch: branch,
      ifscCode: ifscCode,
    );
  }
}