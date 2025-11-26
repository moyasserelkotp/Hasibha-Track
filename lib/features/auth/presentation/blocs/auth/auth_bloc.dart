import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/check_auth_status_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Global authentication BLoC
/// Manages global auth state (authenticated/unauthenticated)
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthUserAuthenticated>(_onUserAuthenticated);
    on<AuthUserUnauthenticated>(_onUserUnauthenticated);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  /// Check if user has valid authentication
  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await checkAuthStatusUseCase();

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (isAuthenticated) {
        if (isAuthenticated) {
          // Note: In a real app, you might want to fetch user data here
          // For now, we'll emit unauthenticated if we have tokens but no user data
          emit(const AuthUnauthenticated());
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  /// User has been authenticated successfully
  void _onUserAuthenticated(
    AuthUserAuthenticated event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthAuthenticated(event.user));
  }

  /// User authentication has been invalidated
  void _onUserUnauthenticated(
    AuthUserUnauthenticated event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }

  /// Logout user
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) {
        // Even if logout fails, clear the state
        emit(const AuthUnauthenticated());
      },
      (_) {
        emit(const AuthUnauthenticated());
      },
    );
  }
}
