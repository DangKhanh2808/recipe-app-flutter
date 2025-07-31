import 'package:equatable/equatable.dart';

abstract class VideoRecipeEvent extends Equatable {
  const VideoRecipeEvent();

  @override
  List<Object?> get props => [];
}

class VideoRecipeStarted extends VideoRecipeEvent {
  const VideoRecipeStarted();
}

class VideoRecipeTabChanged extends VideoRecipeEvent {
  final int tabIndex;

  const VideoRecipeTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class VideoRecipeRefresh extends VideoRecipeEvent {
  const VideoRecipeRefresh();
}

class VideoRecipeLoadMore extends VideoRecipeEvent {
  const VideoRecipeLoadMore();
} 