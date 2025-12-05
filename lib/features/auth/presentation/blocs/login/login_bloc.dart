import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/google_sign_in_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import 'login_event.dart';
import 'login_state.dart';

/// BLoC for login functionality
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final AuthBloc authBloc;

  LoginBloc({
    required this.loginUseCase,
    required this.googleSignInUseCase,
    required this.authBloc,
  }) : super(const LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  /// Handle login request
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    // Use identifier (email or phone) for login
    final result = await loginUseCase(
      identifier: event.identifier,
      password: event.password,
    );

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (authResult) {
        // Notify global auth BLoC
        authBloc.add(AuthUserAuthenticated(authResult.user));
        
        // Emit success state
        emit(LoginSuccess(authResult));
      },
    );
  }

  /// Handle Google Sign-In request
  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    // TODO: Get Google ID token from google_sign_in package
    // For now, pass the ID token from event
    final result = await googleSignInUseCase(event.idToken);

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (authResult) {
        // Notify global auth BLoC
        authBloc.add(AuthUserAuthenticated(authResult.user));
        
        // Emit success state
        emit(LoginSuccess(authResult));
      },
    );
  }
}
