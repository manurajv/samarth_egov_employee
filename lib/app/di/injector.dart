import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_client.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/services/email_service.dart';
import '../../core/services/user_service.dart';
import '../../core/utils/helpers/localization_helper.dart';
import '../../features/auth/data/datasources/auth_remote.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/usecases/auth_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/leaves/presentation/bloc/leave_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart' as profile_datasource;
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import 'modules/leave_module.dart';

final GetIt sl = GetIt.instance;

bool _isDependenciesConfigured = false;

Future<void> configureDependencies() async {
  if (_isDependenciesConfigured) {
    return;
  }

  // Cache SharedPreferences instance
  final sharedPrefs = await SharedPreferences.getInstance();

  // Register LocaleProvider
  if (!sl.isRegistered<LocaleProvider>()) {
    sl.registerLazySingleton(() => LocaleProvider());
  }

  // External packages
  if (!sl.isRegistered<Dio>()) {
    sl.registerSingleton(Dio());
  }
  if (!sl.isRegistered<Connectivity>()) {
    sl.registerLazySingleton(() => Connectivity());
  }
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton(() => const FlutterSecureStorage());
  }
  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerSingleton<SharedPreferences>(sharedPrefs);
  }

  // Services
  if (!sl.isRegistered<EmailService>()) {
    sl.registerLazySingleton(() => EmailService(sl<FlutterSecureStorage>()));
  }

  if (!sl.isRegistered<UserService>()) {
    sl.registerLazySingleton(() => UserService(sl<SharedPreferences>(), sl<FlutterSecureStorage>()));
  }

  // Dio Client
  if (!sl.isRegistered<DioClient>()) {
    sl.registerLazySingleton(() => DioClient(sl<Dio>(), sl<FlutterSecureStorage>()));
  }

  // Network
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<Connectivity>()));
  }

  // Register all leave-related dependencies
  registerLeaveModule(sl);

  // Data sources
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(
        dioClient: sl<DioClient>(),
        emailService: sl<EmailService>(),
      ),
    );
  }
  if (!sl.isRegistered<profile_datasource.ProfileRemoteDataSource>()) {
    sl.registerLazySingleton<profile_datasource.ProfileRemoteDataSource>(
          () => profile_datasource.ProfileRemoteDataSourceImpl(dio: sl<DioClient>().dio),
    );
  }

  // Repositories
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
    );
  }
  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
          () => ProfileRepositoryImpl(
        remoteDataSource: sl<profile_datasource.ProfileRemoteDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );
  }
  if (!sl.isRegistered<DashboardRepository>()) {
    sl.registerLazySingleton<DashboardRepository>(
          () => DashboardRepository(dio: sl<DioClient>().dio),
    );
  }

  // Use cases
  if (!sl.isRegistered<AuthUseCase>()) {
    sl.registerLazySingleton(() => AuthUseCase(
      sl<AuthRepository>(),
      storage: sl<FlutterSecureStorage>(),
      sl<DioClient>(),
      prefs: sl<SharedPreferences>(),
    ));
  }
  if (!sl.isRegistered<GetProfile>()) {
    sl.registerLazySingleton(() => GetProfile(
      sl<ProfileRepository>(),
      prefs: sl<SharedPreferences>(),
      storage: sl<FlutterSecureStorage>(),
    ));
  }
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton(() => ApiClient(
      sl<DioClient>(),
      sl<FlutterSecureStorage>(),
      prefs: sl<SharedPreferences>(),
    ));
  }

  // Blocs
  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory(() => AuthBloc(sl<AuthUseCase>()));
  }
  if (!sl.isRegistered<DashboardBloc>()) {
    sl.registerFactory(() => DashboardBloc(dashboardRepository: sl<DashboardRepository>()));
  }
  if (!sl.isRegistered<ProfileBloc>()) {
    sl.registerFactory(() => ProfileBloc(getProfile: sl<GetProfile>()));
  }
  if (!sl.isRegistered<LeaveBloc>()) {
    sl.registerFactory(() => LeaveBloc());
  }

  _isDependenciesConfigured = true;
}