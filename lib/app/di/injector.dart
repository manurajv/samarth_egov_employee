import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../core/network/network_info.dart';
import '../../core/utils/helpers/localization_helper.dart';
import '../../features/auth/data/datasources/auth_remote.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/usecases/forgot_pwd_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart'; // Add this import

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Register LocaleProvider
  sl.registerLazySingleton(() => LocaleProvider());

  // External packages
  sl.registerSingleton(Dio());

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPwdUsecase(sl()));

  // Blocs
  sl.registerFactory(() => AuthBloc(
    loginUsecase: sl(),
    forgotPwdUsecase: sl(),
  ));

  // Add DashboardBloc registration
  sl.registerFactory(() => DashboardBloc());

  //Profile
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => Connectivity());

// Then register your profile dependencies
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerFactory(() => ProfileBloc(getProfile: sl()));

}