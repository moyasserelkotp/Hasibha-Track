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
import '../features/auth/domain/usecases/reset_password_send_email_usecase.dart';
import '../features/auth/domain/usecases/reset_password_usecase.dart';
import '../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
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
import '../features/budget/data/repositories/budget_repository_impl.dart';
import '../features/budget/domain/repositories/budget_repository.dart';
import '../features/budget/domain/usecases/get_budgets_usecase.dart';
import '../features/budget/domain/usecases/create_budget_usecase.dart';
import '../features/budget/domain/usecases/update_budget_usecase.dart';
import '../features/budget/domain/usecases/delete_budget_usecase.dart';
import '../features/budget/domain/usecases/check_budget_limits_usecase.dart';
import '../features/budget/domain/usecases/update_spent_amount_usecase.dart';
import '../features/budget/presentation/blocs/budget/budget_bloc.dart';

// Analytics Feature
import '../features/analytics/data/datasources/remote/analytics_remote_datasource.dart';
import '../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../features/analytics/domain/repositories/analytics_repository.dart';
import '../features/analytics/domain/usecases/get_spending_analytics_usecase.dart';
import '../features/analytics/domain/usecases/get_category_breakdown_usecase.dart';
import '../features/analytics/domain/usecases/get_monthly_comparison_usecase.dart';
import '../features/analytics/presentation/blocs/analytics_bloc.dart';

// Savings Feature
import '../features/savings/data/datasources/remote/savings_remote_datasource.dart';
import '../features/savings/data/datasources/local/savings_local_datasource.dart';
import '../features/savings/data/repositories/savings_repository_impl.dart';
import '../features/savings/domain/repositories/savings_repository.dart';
import '../features/savings/domain/usecases/get_savings_goals_usecase.dart';
import '../features/savings/domain/usecases/create_savings_goal_usecase.dart';
import '../features/savings/domain/usecases/update_savings_goal_usecase.dart';
import '../features/savings/domain/usecases/delete_savings_goal_usecase.dart';
import '../features/savings/domain/usecases/add_funds_to_goal_usecase.dart';
import '../features/savings/domain/usecases/withdraw_funds_from_goal_usecase.dart';
import '../features/savings/presentation/blocs/savings_bloc.dart';
import '../features/expense/domain/usecases/update_expense_usecase.dart';
import '../features/expense/domain/usecases/delete_expense_usecase.dart';
import '../features/expense/domain/usecases/get_categories_usecase.dart';
import '../features/expense/domain/usecases/import_expense_from_image_usecase.dart';
import '../features/expense/presentation/blocs/expense/expense_bloc.dart';
import '../features/expense/presentation/blocs/category/category_bloc.dart';
import '../features/budget/data/datasources/remote/budget_remote_datasource.dart';
import '../features/budget/data/datasources/local/budget_local_datasource.dart';

// Debt Feature
import '../features/debt/data/datasources/remote/debt_remote_datasource.dart';
import '../features/debt/data/datasources/local/debt_local_datasource.dart';
import '../features/debt/data/repositories/debt_repository_impl.dart';
import '../features/debt/domain/repositories/debt_repository.dart';
import '../features/debt/domain/usecases/get_debts_usecase.dart';
import '../features/debt/domain/usecases/create_debt_usecase.dart';
import '../features/debt/domain/usecases/update_debt_usecase.dart';
import '../features/debt/domain/usecases/delete_debt_usecase.dart';
import '../features/debt/domain/usecases/add_payment_usecase.dart';
import '../features/debt/domain/usecases/get_debt_summary_usecase.dart';
import '../features/debt/presentation/blocs/debt_bloc.dart ';

// Settings & Services
import '../shared/services/export_service.dart';
import '../shared/services/backup_service.dart';
import '../shared/services/voice_input_service.dart';
import '../shared/services/enhanced_ocr_service.dart';
import '../shared/services/pdf_parser_service.dart';
import '../shared/services/ai/mock_ai_service.dart';
import '../shared/services/recommendation_engine.dart';
import '../shared/services/ocr_service.dart';
import '../shared/services/budget_expense_sync_service.dart';
import '../shared/domain/repositories/settings_repository.dart';
import '../shared/data/repositories/settings_repository_impl.dart';
import '../shared/domain/usecases/get_settings_usecase.dart';
import '../shared/domain/usecases/update_settings_usecase.dart';
import '../shared/cubit/settings_cubit.dart';
import '../shared/cubit/theme_cubit.dart';



final sl = GetIt.instance;

// Configuration: Set to true to use mock data (no backend required)
const bool USE_MOCK_DATA = true;

Future<void> init() async {
  // ! External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);

  // Initialize CacheHelper with SharedPreferences and SecureStorage
  CacheHelper.sharedPreferences = sharedPreferences;
  CacheHelper.secureStorage = secureStorage;

  // --- Hive Boxes ---
  // Helper function to open or reuse box
  Future<Box<T>> openBoxSafely<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      // Close the existing box if it's open with wrong type
      try {
        await Hive.box(name).close();
      } catch (e) {
        // Box might already be closed or have different type, ignore
      }
    }
    return await Hive.openBox<T>(name);
  }

  // Open all boxes safely
  final categoryBox = await openBoxSafely<Map<dynamic, dynamic>>('categories');
  final expenseBox = await openBoxSafely<Map<dynamic, dynamic>>('expenses');

  final budgetBox = await openBoxSafely<Map<dynamic, dynamic>>('budgets');
  final savingsBox = await openBoxSafely<Map<dynamic, dynamic>>('savings_goals');
  final debtBox = await openBoxSafely<Map<dynamic, dynamic>>('debts');

  // Register boxes with unique instance names
  sl.registerLazySingleton(() => categoryBox, instanceName: 'categoryBox');
  sl.registerLazySingleton(() => expenseBox, instanceName: 'expenseBox');

  sl.registerLazySingleton(() => budgetBox, instanceName: 'budgetBox');
  sl.registerLazySingleton(() => savingsBox, instanceName: 'savingsBox');
  sl.registerLazySingleton(() => debtBox, instanceName: 'debtBox');

  // --- Dio with interceptor ---
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
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
  // Use mock data source for testing without backend
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordSendEmailUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(repository: sl()));
  
  sl.registerLazySingleton(() => GoogleSignInUseCase(repository: sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));

  // BLoCs
  sl.registerLazySingleton(() => AuthBloc(
    checkAuthStatusUseCase: sl(),
    getCurrentUserUseCase: sl(),
    logoutUseCase: sl(),
  ));
  sl.registerFactory(() => LoginBloc(
    loginUseCase: sl(),
    googleSignInUseCase: sl(),
    authBloc: sl(),
  ));
  sl.registerFactory(() => RegisterBloc(
    registerUseCase: sl(),
    authBloc: sl(),
  ));
  sl.registerFactory(() => PasswordBloc(
    resetPasswordSendEmailUseCase: sl(),
    resetPasswordUseCase: sl(),
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
  sl.registerLazySingleton(() => OcrService());
  sl.registerLazySingleton(() => BudgetExpenseSyncService(budgetRepository: sl()));
  sl.registerLazySingleton<ExpenseRemoteDataSource>(() => ExpenseRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<ExpenseLocalDataSource>(() => ExpenseLocalDataSourceImpl(
    expenseBox: sl(instanceName: 'expenseBox'),
    categoryBox: sl(instanceName: 'categoryBox'),
  ));
  sl.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    ocrService: sl(),
  ));
  sl.registerLazySingleton(() => GetExpensesUseCase(sl()));
  sl.registerLazySingleton(() => CreateExpenseUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExpenseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => ImportExpenseFromImageUseCase(sl()));
  sl.registerFactory(() => ExpenseBloc(
    getExpensesUseCase: sl(),
    createExpenseUseCase: sl(),
    updateExpenseUseCase: sl(),
    deleteExpenseUseCase: sl(),
    importExpenseFromImageUseCase: sl(),
    budgetSyncService: sl(),
  ));
  sl.registerFactory(() => CategoryBloc(getCategoriesUseCase: sl()));

  // --- Budget ---
  sl.registerLazySingleton<BudgetRemoteDataSource>(() => BudgetRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<BudgetLocalDataSource>(() => BudgetLocalDataSourceImpl(budgetBox: sl(instanceName: 'budgetBox')));
  sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));
  sl.registerLazySingleton(() => GetBudgetsUseCase(sl()));
  sl.registerLazySingleton(() => CreateBudgetUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBudgetUseCase(sl()));
  sl.registerLazySingleton(() => DeleteBudgetUseCase(sl()));
  sl.registerLazySingleton(() => CheckBudgetLimitsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSpentAmountUseCase(sl()));
  sl.registerFactory(() => BudgetBloc(
    getBudgetsUseCase: sl(),
    createBudgetUseCase: sl(),
    updateBudgetUseCase: sl(),
    deleteBudgetUseCase: sl(),
    checkBudgetLimitsUseCase: sl(),
  ));

  // --- Analytics ---
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(() => AnalyticsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AnalyticsRepository>(() => AnalyticsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetSpendingAnalyticsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoryBreakdownUseCase(sl()));
  sl.registerLazySingleton(() => GetMonthlyComparisonUseCase(sl()));
  sl.registerFactory(() => AnalyticsBloc(
    getSpendingAnalyticsUseCase: sl(),
    getMonthlyComparisonUseCase: sl(),
  ));

  // --- Savings ---
  sl.registerLazySingleton<SavingsRemoteDataSource>(() => SavingsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<SavingsLocalDataSource>(() => SavingsLocalDataSourceImpl(savingsBox: sl(instanceName: 'savingsBox')));
  sl.registerLazySingleton<SavingsRepository>(() => SavingsRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));
  sl.registerLazySingleton(() => GetSavingsGoalsUseCase(sl()));
  sl.registerLazySingleton(() => CreateSavingsGoalUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSavingsGoalUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSavingsGoalUseCase(sl()));
  sl.registerLazySingleton(() => AddFundsToGoalUseCase(sl()));
  sl.registerLazySingleton(() => WithdrawFundsFromGoalUseCase(sl()));
  sl.registerFactory(() => SavingsBloc(
    getSavingsGoalsUseCase: sl(),
    createSavingsGoalUseCase: sl(),
    updateSavingsGoalUseCase: sl(),
    deleteSavingsGoalUseCase: sl(),
    addFundsToGoalUseCase: sl(),
    withdrawFundsFromGoalUseCase: sl(),
  ));

  // --- Debt ---
  sl.registerLazySingleton<DebtRemoteDataSource>(() => DebtRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<DebtLocalDataSource>(() => DebtLocalDataSourceImpl(debtBox: sl(instanceName: 'debtBox')));
  sl.registerLazySingleton<DebtRepository>(() => DebtRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));
  sl.registerLazySingleton(() => GetDebtsUseCase(sl()));
  sl.registerLazySingleton(() => CreateDebtUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDebtUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDebtUseCase(sl()));
  sl.registerLazySingleton(() => AddPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetDebtSummaryUseCase(sl()));
  sl.registerFactory(() => DebtBloc(
    getDebtsUseCase: sl(),
    createDebtUseCase: sl(),
    updateDebtUseCase: sl(),
    deleteDebtUseCase: sl(),
    addPaymentUseCase: sl(),
    getDebtSummaryUseCase: sl(),
  ));

  // --- AI & Input Services ---
  sl.registerLazySingleton(() => VoiceInputService());
  sl.registerLazySingleton(() => EnhancedOcrService());
  sl.registerLazySingleton(() => PdfParserService());
  sl.registerLazySingleton(() => MockAiService());
  sl.registerLazySingleton(() => RecommendationEngine());

  // --- Settings & Services ---
  sl.registerLazySingleton(() => ExportService());
  sl.registerLazySingleton(() => BackupService(localDataSource: sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetSettingsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(repository: sl()));
  sl.registerFactory(() => SettingsCubit(getSettingsUseCase: sl(), updateSettingsUseCase: sl()));
  sl.registerFactory(() => ThemeCubit(sharedPreferences: sl()));
}

