import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingLoaded extends OnboardingState {
  final int currentPage;
  final int totalPages;
  final bool isLastPage;
  final bool isFirstPage;

  const OnboardingLoaded({
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
    required this.isFirstPage,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, isLastPage, isFirstPage];

  OnboardingLoaded copyWith({
    int? currentPage,
    int? totalPages,
    bool? isLastPage,
    bool? isFirstPage,
  }) {
    return OnboardingLoaded(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLastPage: isLastPage ?? this.isLastPage,
      isFirstPage: isFirstPage ?? this.isFirstPage,
    );
  }
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