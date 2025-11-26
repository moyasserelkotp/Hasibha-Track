import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_auth_status_usecase.dart';

import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashNavigate extends SplashState {
  final String route;
  const SplashNavigate(this.route);

  @override
  List<Object?> get props => [route];
}

class SplashError extends SplashState {
  final String message;
  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}

class SplashCubit extends Cubit<SplashState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  SplashCubit({required this.checkAuthStatusUseCase}) : super(SplashInitial());

  void checkAuthStatus() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    
    final result = await checkAuthStatusUseCase.call();
    
    result.fold(
      (failure) => emit(SplashError(failure.message)),
      (appStatus) => emit(SplashNavigate(appStatus.nextRoute)),
    );
  }
}
