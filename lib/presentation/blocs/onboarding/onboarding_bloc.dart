import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_events.dart';
import 'onboarding_states.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const int _totalPages = 3;

  OnboardingBloc() : super(const OnboardingInitial()) {
    on<OnboardingStarted>(_onOnboardingStarted);
    on<OnboardingNextPage>(_onOnboardingNextPage);
    on<OnboardingPreviousPage>(_onOnboardingPreviousPage);
    on<OnboardingSkip>(_onOnboardingSkip);
    on<OnboardingComplete>(_onOnboardingComplete);
    on<OnboardingPageChanged>(_onOnboardingPageChanged);
  }

  void _onOnboardingStarted(OnboardingStarted event, Emitter<OnboardingState> emit) {
    emit(const OnboardingLoaded(
      currentPage: 0,
      totalPages: _totalPages,
      isLastPage: false,
      isFirstPage: true,
    ));
  }

  void _onOnboardingNextPage(OnboardingNextPage event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final nextPage = currentState.currentPage + 1;
      
      if (nextPage < _totalPages) {
        emit(currentState.copyWith(
          currentPage: nextPage,
          isLastPage: nextPage == _totalPages - 1,
          isFirstPage: false,
        ));
      }
    }
  }

  void _onOnboardingPreviousPage(OnboardingPreviousPage event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final previousPage = currentState.currentPage - 1;
      
      if (previousPage >= 0) {
        emit(currentState.copyWith(
          currentPage: previousPage,
          isLastPage: false,
          isFirstPage: previousPage == 0,
        ));
      }
    }
  }

  void _onOnboardingSkip(OnboardingSkip event, Emitter<OnboardingState> emit) {
    emit(const OnboardingCompleted());
  }

  void _onOnboardingComplete(OnboardingComplete event, Emitter<OnboardingState> emit) {
    emit(const OnboardingCompleted());
  }

  void _onOnboardingPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      emit(currentState.copyWith(
        currentPage: event.pageIndex,
        isLastPage: event.pageIndex == _totalPages - 1,
        isFirstPage: event.pageIndex == 0,
      ));
    }
  }
} 