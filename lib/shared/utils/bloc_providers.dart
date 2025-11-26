import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart' as di;
import '../../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../cubit/settings_cubit.dart';


class AppBlocProviders {
  /// Wraps the child widget with all necessary BLoC providers
  /// 
  /// Currently provides:
  /// - AuthBloc: Manages global authentication state (authenticated/unauthenticated)
  /// - SettingsCubit: Manages app settings globally
  /// 
  /// Note: LoginBloc, RegisterBloc, and PasswordBloc are provided locally in their screens
  static Widget getBlocProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        // Global Auth BLoC - Manages authentication state across the app
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
          lazy: false, // Initialize immediately to check auth state
        ),
        // Settings Cubit - Global settings management
        BlocProvider<SettingsCubit>(
          create: (context) => di.sl<SettingsCubit>()..loadSettings(),
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
