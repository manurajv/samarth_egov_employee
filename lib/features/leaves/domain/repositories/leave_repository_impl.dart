import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/leave_remote_data_source.dart';
import '../../data/models/leave_balance.dart';
import '../../data/models/leave_history.dart';
import '../../data/models/leave_status.dart';
import '../usecases/apply_leave.dart';
import 'leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LeaveRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> applyLeave(LeaveParams params, String organizationSlug) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.applyLeave(params, organizationSlug);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure('Server error occurred: ${e.message}'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances(String email, String organizationSlug) async {
    if (await networkInfo.isConnected) {
      try {
        final balances = await remoteDataSource.getLeaveBalances(email, organizationSlug);
        return Right(balances);
      } on ServerException catch (e) {
        return Left(ServerFailure('Server error occurred: ${e.message}'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveHistory>>> getLeaveHistory(String email, String organizationSlug) async {
    if (await networkInfo.isConnected) {
      try {
        final history = await remoteDataSource.getLeaveHistory(email, organizationSlug);
        return Right(history);
      } on ServerException catch (e) {
        return Left(ServerFailure('Server error occurred: ${e.message}'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveStatus>>> getLeaveStatuses(String email, String organizationSlug) async {
    if (await networkInfo.isConnected) {
      try {
        final statuses = await remoteDataSource.getLeaveStatuses(email, organizationSlug);
        return Right(statuses);
      } on ServerException catch (e) {
        return Left(ServerFailure('Server error occurred: ${e.message}'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}