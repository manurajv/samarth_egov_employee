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
  Future<Either<Failure, void>> applyLeave(LeaveParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.applyLeave(params);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure('Server error occurred: Leave Apply'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances() async {
    if (await networkInfo.isConnected) {
      try {
        final balances = await remoteDataSource.getLeaveBalances();
        return Right(balances);
      } on ServerException {
        return Left(ServerFailure('Server error occurred: Leave Balance'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveHistory>>> getLeaveHistory() async {
    if (await networkInfo.isConnected) {
      try {
        final history = await remoteDataSource.getLeaveHistory();
        return Right(history);
      } on ServerException {
        return Left(ServerFailure('Server error occurred: Leave History'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveStatus>>> getLeaveStatuses() async {
    if (await networkInfo.isConnected) {
      try {
        final statuses = await remoteDataSource.getLeaveStatuses();
        return Right(statuses);
      } on ServerException {
        return Left(ServerFailure('Server error occurred: Leave Status'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}