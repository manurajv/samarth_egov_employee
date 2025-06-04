import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/leave_balance.dart';
import '../repositories/leave_repository.dart';

class GetLeaveBalances {
  final LeaveRepository repository;

  GetLeaveBalances(this.repository);

  Future<Either<Failure, List<LeaveBalance>>> call() async {
    return await repository.getLeaveBalances();
  }
}