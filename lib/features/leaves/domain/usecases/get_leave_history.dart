import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/leave_history.dart';
import '../repositories/leave_repository.dart';

class GetLeaveHistory {
  final LeaveRepository repository;

  GetLeaveHistory(this.repository);

  Future<Either<Failure, List<LeaveHistory>>> call(String email, String organizationSlug) async {
    return await repository.getLeaveHistory(email, organizationSlug);
  }
}