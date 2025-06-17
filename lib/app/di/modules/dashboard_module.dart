import 'package:get_it/get_it.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

class DashboardModule {
  final GetIt getIt;

  DashboardModule(this.getIt) {
    _configure();
  }

  void _configure() {
    getIt.registerFactory(() => DashboardBloc());
  }
}