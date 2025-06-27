import 'package:get_it/get_it.dart';
import '../../../core/network/dio_client.dart';
import '../../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

class DashboardModule {
  final GetIt getIt;

  DashboardModule(this.getIt) {
    _configure();
  }

  void _configure() {
    if (!getIt.isRegistered<DashboardRepository>()) {
      getIt.registerLazySingleton<DashboardRepository>(
            () => DashboardRepository(dio: getIt<DioClient>().dio),
      );
    }
    getIt.registerFactory(() => DashboardBloc(dashboardRepository: getIt<DashboardRepository>()));
  }
}