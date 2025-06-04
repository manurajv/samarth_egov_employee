import 'package:get_it/get_it.dart';

import '../../../features/leaves/data/datasources/leave_remote_data_source.dart';
import '../../../features/leaves/domain/repositories/leave_repository.dart';
import '../../../features/leaves/domain/repositories/leave_repository_impl.dart';
import '../../../features/leaves/domain/usecases/apply_leave.dart';
import '../../../features/leaves/domain/usecases/get_leave_balance.dart';
import '../../../features/leaves/domain/usecases/get_leave_history.dart';
import '../../../features/leaves/domain/usecases/get_leave_status.dart';
import '../../../features/leaves/presentation/bloc/leave_balance_bloc.dart';
import '../../../features/leaves/presentation/bloc/leave_form_bloc.dart';
import '../../../features/leaves/presentation/bloc/leave_history_bloc.dart';
import '../../../features/leaves/presentation/bloc/leave_status_bloc.dart';

void registerLeaveModule(GetIt sl) {
  // Data Sources
  if (!sl.isRegistered<LeaveRemoteDataSource>()) {
    sl.registerLazySingleton<LeaveRemoteDataSource>(
          () => LeaveRemoteDataSourceImpl(dio: sl()),
    );
  }

  // Repositories
  if (!sl.isRegistered<LeaveRepository>()) {
    sl.registerLazySingleton<LeaveRepository>(
          () => LeaveRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
  }

  // Use Cases
  if (!sl.isRegistered<ApplyLeave>()) {
    sl.registerLazySingleton(() => ApplyLeave(sl()));
  }
  if (!sl.isRegistered<GetLeaveBalances>()) {
    sl.registerLazySingleton(() => GetLeaveBalances(sl()));
  }
  if (!sl.isRegistered<GetLeaveHistory>()) {
    sl.registerLazySingleton(() => GetLeaveHistory(sl()));
  }
  if (!sl.isRegistered<GetLeaveStatus>()) {
    sl.registerLazySingleton(() => GetLeaveStatus(sl()));
  }

  // Blocs
  if (!sl.isRegistered<LeaveFormBloc>()) {
    sl.registerFactory(() => LeaveFormBloc(applyLeave: sl()));
  }
  if (!sl.isRegistered<LeaveBalanceBloc>()) {
    sl.registerFactory(() => LeaveBalanceBloc(sl()));
  }
  if (!sl.isRegistered<LeaveHistoryBloc>()) {
    sl.registerFactory(() => LeaveHistoryBloc(sl()));
  }
  if (!sl.isRegistered<LeaveStatusBloc>()) {
    sl.registerFactory(() => LeaveStatusBloc(sl()));
  }
}