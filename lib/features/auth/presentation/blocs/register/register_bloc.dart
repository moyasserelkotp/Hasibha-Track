import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import 'register_event.dart';
import 'register_state.dart';

/// BLoC for registration
/// New backend returns tokens immediately after successful registration
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  final AuthBloc authBloc;

  RegisterBloc({
    required this.registerUseCase,
    required this.authBloc,
  }) : super(const RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  /// Handle registration request
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    final result = await registerUseCase(
      username: event.username,
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      phone: event.phone,
    );

    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (authResult) {
        // Notify global auth BLoC - user is now authenticated
        authBloc.add(AuthUserAuthenticated(authResult.user));
        
        // Emit success state with auth result
        emit(RegisterSuccess(authResult));
      },
    );
  }
}
