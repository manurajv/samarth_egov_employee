import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/services/email_service.dart';
import '../../core/utils/helpers/localization_helper.dart';
import '../../features/auth/data/datasources/auth_remote.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/usecases/auth_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/leaves/presentation/bloc/leave_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import 'modules/leave_module.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Register LocaleProvider
  sl.registerLazySingleton(() => LocaleProvider());

  // External packages
  sl.registerSingleton(Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Services
  sl.registerLazySingleton(() => EmailService(sl<FlutterSecureStorage>()));

  // Dio Client
  sl.registerLazySingleton(() => DioClient(sl<Dio>(), sl<FlutterSecureStorage>()));

  // Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<Connectivity>()));

  // Register all leave-related dependencies
  registerLeaveModule(sl);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      emailService: sl<EmailService>(),
    ),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AuthUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetProfile(sl<ProfileRepository>()));

  // Blocs
  sl.registerFactory(() => AuthBloc(sl<AuthUseCase>()));
  sl.registerFactory(() => DashboardBloc());
  sl.registerFactory(() => ProfileBloc(getProfile: sl<GetProfile>()));
  sl.registerFactory(() => LeaveBloc());
}