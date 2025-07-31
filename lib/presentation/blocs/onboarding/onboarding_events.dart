import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

class OnboardingNextPage extends OnboardingEvent {
  const OnboardingNextPage();
}

class OnboardingPreviousPage extends OnboardingEvent {
  const OnboardingPreviousPage();
}

class OnboardingSkip extends OnboardingEvent {
  const OnboardingSkip();
}

class OnboardingComplete extends OnboardingEvent {
  const OnboardingComplete();
}

class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
} 