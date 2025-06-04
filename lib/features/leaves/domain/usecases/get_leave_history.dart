import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/leave_history.dart';
import '../repositories/leave_repository.dart';

class GetLeaveHistory {
  final LeaveRepository repository;

  GetLeaveHistory(this.repository);

  Future<Either<Failure, List<LeaveHistory>>> call() async {
    return await repository.getLeaveHistory();
  }
}