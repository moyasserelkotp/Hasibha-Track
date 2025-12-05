import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasibha/shared/theme/app_theme.dart';
import 'package:hasibha/shared/utils/bloc_providers.dart';
import 'package:hasibha/shared/utils/app_router.dart';
import 'package:hasibha/shared/const/app_strings.dart';
import 'package:photo_manager/photo_manager.dart';

import 'di/injection.dart' as di;
import 'shared/local/hive_service.dart';
import 'shared/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await di.init();

  PhotoManager.setIgnorePermissionCheck(false);
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => di.sl<ThemeCubit>(),
      child: AppBlocProviders.getBlocProviders(
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              builder: (context, child) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  title: AppStrings.appName,
                  routerConfig: AppRouter.router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
