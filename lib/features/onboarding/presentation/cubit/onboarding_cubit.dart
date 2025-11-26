import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_onboarding_usecase.dart';

import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingPageChanged extends OnboardingState {
  final int index;
  const OnboardingPageChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboardingUseCase completeOnboardingUseCase;
  
  OnboardingCubit({required this.completeOnboardingUseCase}) : super(OnboardingInitial());

  int currentPage = 0;

  void onPageChanged(int index) {
    currentPage = index;
    emit(OnboardingPageChanged(index));
  }

  Future<void> completeOnboarding() async {
    emit(OnboardingLoading());
    final result = await completeOnboardingUseCase.call();
    
    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (success) => emit(OnboardingCompleted()),
    );
  }
}
