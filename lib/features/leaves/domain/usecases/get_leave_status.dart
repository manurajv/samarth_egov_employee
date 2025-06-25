import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/leave_status.dart';
import '../repositories/leave_repository.dart';

class GetLeaveStatus {
  final LeaveRepository repository;

  GetLeaveStatus(this.repository);

  Future<Either<Failure, List<LeaveStatus>>> call(String email, String organizationSlug) async {
    return await repository.getLeaveStatuses(email, organizationSlug);
  }
}