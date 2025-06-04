import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/leave_balance.dart';
import '../repositories/leave_repository.dart';

class GetLeaveBalances {
  final LeaveRepository repository;

  GetLeaveBalances(this.repository);

  Future<Either<Failure, List<LeaveBalance>>> call() async {
    return await repository.getLeaveBalances();
  }
}