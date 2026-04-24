import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';
import 'package:sibaha_app/data/repositories/auth_repository.dart';
import 'package:sibaha_app/data/repositories/pool_repository.dart';
import 'package:sibaha_app/data/repositories/user_repository.dart';
import 'package:sibaha_app/data/services/academy_service.dart';
import 'package:sibaha_app/data/services/auth_service.dart';
import 'package:sibaha_app/data/services/pool_service.dart';
import 'package:sibaha_app/data/services/user_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<Dio>(Dio());

  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<Dio>()));
  getIt.registerLazySingleton<AcademyService>(() => AcademyService(getIt<Dio>()));
  getIt.registerLazySingleton<PoolService>(() => PoolService(getIt<Dio>()));
  getIt.registerLazySingleton<UserService>(() => UserService(getIt<Dio>()));

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<AuthService>()));
  getIt.registerLazySingleton<AcademyRepository>(() => AcademyRepository(getIt<AcademyService>()));
  getIt.registerLazySingleton<PoolRepository>(() => PoolRepository(getIt<PoolService>()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepository(getIt<UserService>()));
}
