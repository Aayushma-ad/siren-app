import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siren_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:siren_app/core/network/connection_checker.dart';
import 'package:siren_app/core/secrets/app_secrets.dart';
import 'package:siren_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:siren_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:siren_app/features/auth/domain/repository/auth_repository.dart';
import 'package:siren_app/features/auth/domain/usecases/current_user.dart';
import 'package:siren_app/features/auth/domain/usecases/user_login.dart';
import 'package:siren_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:siren_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:siren_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:siren_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:siren_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:siren_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:siren_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:siren_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:siren_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // 1️⃣ Init external services first
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Open Hive box (await, so we get Box, not Future<Box>)
  final blogsBox = await Hive.openBox('blogs');

  // 2️⃣ Register low-level dependencies
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  // Register the actual Box<dynamic>
  serviceLocator.registerLazySingleton<Box<dynamic>>(() => blogsBox);
  // If you have a typed box, do:
  // serviceLocator.registerLazySingleton<Box<BlogModel>>(() => blogsBox);

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImp(serviceLocator()),
  );

  // 3️⃣ Register feature layers
  _initAuth();
  _initBlog();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // Usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
