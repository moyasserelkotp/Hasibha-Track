// Flutter & Core Packages
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../shared/core/local/cache_helper.dart';
import '../shared/core/network/auth_interceptor.dart';
import '../shared/core/api/api_constants.dart';

// Splash Feature
import '../features/splash/data/datasources/local/splash_local_data_source.dart';
import '../features/splash/data/datasources/local/splash_local_data_source_impl.dart';
import '../features/splash/data/repositories/splash_repository_impl.dart';
import '../features/splash/domain/repositories/splash_repository.dart';
import '../features/splash/domain/usecases/check_auth_status_usecase.dart' as splash;
import '../features/splash/presentation/cubit/splash_cubit.dart';

// Onboarding Feature
import '../features/onboarding/data/datasources/local/onboarding_local_data_source.dart';
import '../features/onboarding/data/datasources/local/onboarding_local_data_source_impl.dart';
import '../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import '../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../features/onboarding/presentation/cubit/onboarding_cubit.dart';

// Auth Feature
import '../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import '../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../features/auth/data/datasources/local/auth_local_datasource_impl.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/google_sign_in_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/refresh_token_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../features/auth/domain/usecases/reset_password_send_email_usecase.dart';
import '../features/auth/domain/usecases/reset_password_finish_usecase.dart';
import '../features/auth/domain/usecases/reset_password_verify_otp_usecase.dart';
import '../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../features/auth/domain/usecases/change_password_usecase.dart';
import '../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/core/services/token_service.dart';
import '../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../features/auth/presentation/blocs/login/login_bloc.dart';
import '../features/auth/presentation/blocs/register/register_bloc.dart';
import '../features/auth/presentation/blocs/password/password_bloc.dart';

// Home Feature
import '../features/home/data/datasources/remote/home_remote_data_source.dart';
import '../features/home/data/datasources/remote/home_remote_data_source_impl.dart';
import '../features/home/data/datasources/local/home_local_data_source.dart';
import '../features/home/data/datasources/local/home_local_data_source_impl.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import '../features/home/domain/usecases/get_recent_transactions_usecase.dart';
import '../features/home/domain/usecases/add_transaction_usecase.dart';
import '../features/home/domain/usecases/get_analytics_usecase.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/home/presentation/cubit/add_transaction_cubit.dart';
import '../features/home/presentation/cubit/analytics_cubit.dart';

// Expense Feature
import 'package:hive/hive.dart';
import '../features/expense/data/datasources/remote/expense_remote_datasource.dart';
import '../features/expense/data/datasources/local/expense_local_datasource.dart';
import '../features/expense/data/repositories/expense_repository_impl.dart';
import '../features/expense/domain/repositories/expense_repository.dart';
import '../features/expense/domain/usecases/get_expenses_usecase.dart';
import '../features/expense/domain/usecases/create_expense_usecase.dart';
import '../features/expense/domain/usecases/update_expense_usecase.dart';
import '../features/expense/domain/usecases/delete_expense_usecase.dart';
import '../features/expense/domain/usecases/get_categories_usecase.dart';
import '../features/expense/domain/usecases/import_expense_from_image_usecase.dart';
import '../features/expense/presentation/blocs/expense/expense_bloc.dart';
import '../features/expense/presentation/blocs/category/category_bloc.dart';
import '../shared/services/ocr_service.dart';

// Settings & Services
import '../shared/services/export_service.dart';
import '../shared/services/backup_service.dart';
import '../shared/domain/repositories/settings_repository.dart';
import '../shared/data/repositories/settings_repository_impl.dart';
import '../shared/domain/usecases/get_settings_usecase.dart';
import '../shared/domain/usecases/update_settings_usecase.dart';
import '../shared/cubit/settings_cubit.dart';
import '../shared/cubit/theme_cubit.dart';



final sl = GetIt.instance;

Future<void> init() async {
  // ! External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);
  
  // Initialize CacheHelper with SharedPreferences and SecureStorage
  CacheHelper.sharedPreferences = sharedPreferences;
  CacheHelper.secureStorage = secureStorage;
  
  // Dio with interceptor
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  // Add auth interceptor
  dio.interceptors.add(AuthInterceptor(dio: dio));
  sl.registerLazySingleton(() => dio);

  // ! Features

  // --- Splash ---
  sl.registerLazySingleton<SplashLocalDataSource>(() => SplashLocalDataSourceImpl());
  sl.registerLazySingleton<SplashRepository>(() => SplashRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => splash.CheckAuthStatusUseCase(repository: sl()));
  sl.registerFactory(() => SplashCubit(checkAuthStatusUseCase: sl()));

  // --- Onboarding ---
  sl.registerLazySingleton<OnboardingLocalDataSource>(() => OnboardingLocalDataSourceImpl());
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => CompleteOnboardingUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckOnboardingStatusUseCase(repository: sl()));
  sl.registerFactory(() => OnboardingCubit(completeOnboardingUseCase: sl()));

  // --- Auth ---
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(
    () => TokenService(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordSendEmailUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordVerifyOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordFinishUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(repository: sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));

  // BLoCs
  sl.registerLazySingleton(() => AuthBloc(
        checkAuthStatusUseCase: sl(),
        logoutUseCase: sl(),
      ));

  sl.registerFactory(() => LoginBloc(
        loginUseCase: sl(),
        googleSignInUseCase: sl(),
        authBloc: sl(),
      ));

  sl.registerFactory(() => RegisterBloc(
        registerUseCase: sl(),
        verifyOtpUseCase: sl(),
        resendOtpUseCase: sl(),
        authBloc: sl(),
      ));

  sl.registerFactory(() => PasswordBloc(
        resetPasswordSendEmailUseCase: sl(),
        resetPasswordVerifyOtpUseCase: sl(),
        resetPasswordFinishUseCase: sl(),
        changePasswordUseCase: sl(),
      ));

  // --- Home ---
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImpl());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));
  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetRecentTransactionsUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));
  sl.registerLazySingleton(() => GetAnalyticsUseCase(sl()));
  sl.registerFactory(() => HomeCubit(getDashboardSummaryUseCase: sl()));
  sl.registerFactory(() => AddTransactionCubit(sl()));
  sl.registerFactory(() => AnalyticsCubit(sl()));

  // --- Expense ---
  // Services
  sl.registerLazySingleton(() => OcrService());
  
  // Hive boxes for local storage
  final expenseBox = await Hive.openBox<Map<dynamic, dynamic>>('expenses');
  final categoryBox = await Hive.openBox<Map<dynamic, dynamic>>('categories');
  sl.registerLazySingleton(() => expenseBox);
  sl.registerLazySingleton(() => categoryBox);
  
  // Data Sources
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(
      expenseBox: sl(),
      categoryBox: sl(),
    ),
  );
  
  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      ocrService: sl(),
    ),
  );
  
  // Use Cases
  sl.registerLazySingleton(() => GetExpensesUseCase(sl()));
  sl.registerLazySingleton(() => CreateExpenseUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExpenseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => ImportExpenseFromImageUseCase(sl()));
  
  // BLoCs
  sl.registerFactory(() => ExpenseBloc(
    getExpensesUseCase: sl(),
    createExpenseUseCase: sl(),
    updateExpenseUseCase: sl(),
    deleteExpenseUseCase: sl(),
    importExpenseFromImageUseCase: sl(),
  ));
  sl.registerFactory(() => CategoryBloc(getCategoriesUseCase: sl()));

  // --- Settings & Services ---
  // Services
  sl.registerLazySingleton(() => ExportService());
  sl.registerLazySingleton(() => BackupService(localDataSource: sl()));
  
  // Repository
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(localDataSource: sl()));
  
  // Use Cases
  sl.registerLazySingleton(() => GetSettingsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(repository: sl()));
  
  // Cubits
  sl.registerFactory(() => SettingsCubit(
        getSettingsUseCase: sl(),
        updateSettingsUseCase: sl(),
      ));
  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));
}
