import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/leave_repository.dart';
import '../../data/models/leave_balance.dart';

class GetLeaveBalances {
  final LeaveRepository repository;

  GetLeaveBalances(this.repository);

  Future<Either<Failure, List<LeaveBalance>>> call(String email, String organizationSlug) async {
    return await repository.getLeaveBalances(email, organizationSlug);
  }
}