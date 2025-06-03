import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
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
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    print('Checking network connection...');
    if (await networkInfo.isConnected) {
      print('Network connected, fetching profile...');
      try {
        final profile = await remoteDataSource.getProfile();
        print('Profile data received: $profile');
        return Right(profile.toEntity());
      } catch (e) {
        print('Error fetching profile: $e');
        String errorMessage;
        if (e is ServerException) {
          errorMessage = e.message.contains('null or missing')
              ? 'Profile data not found on server'
              : e.message.contains('Network error')
              ? 'Unable to connect to the server'
              : 'Server error: ${e.message}';
        } else {
          errorMessage = 'Unexpected error occurred';
        }
        return Left(ServerFailure(errorMessage));
      }
    } else {
      print('No network connection');
      return Left(const NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity profile) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProfile(
          ProfileModel.fromEntity(profile),
        );
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(e.message ?? 'Unknown Dio error'));
      }
    } else {
      return Left(const NetworkFailure()); // Added const
    }
  }
}