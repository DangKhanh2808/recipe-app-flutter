import 'package:equatable/equatable.dart';
import '../../../domain/entities/recipe.dart';

abstract class VideoRecipeState extends Equatable {
  const VideoRecipeState();

  @override
  List<Object?> get props => [];
}

class VideoRecipeInitial extends VideoRecipeState {
  const VideoRecipeInitial();
}

class VideoRecipeLoading extends VideoRecipeState {
  const VideoRecipeLoading();
}

class VideoRecipeLoaded extends VideoRecipeState {
  final List<Recipe> videoRecipes;
  final List<Recipe> recipeRecipes;
  final int currentTabIndex;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const VideoRecipeLoaded({
    required this.videoRecipes,
    required this.recipeRecipes,
    required this.currentTabIndex,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  VideoRecipeLoaded copyWith({
    List<Recipe>? videoRecipes,
    List<Recipe>? recipeRecipes,
    int? currentTabIndex,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return VideoRecipeLoaded(
      videoRecipes: videoRecipes ?? this.videoRecipes,
      recipeRecipes: recipeRecipes ?? this.recipeRecipes,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        videoRecipes,
        recipeRecipes,
        currentTabIndex,
        isLoadingMore,
        hasReachedMax,
      ];
}

class VideoRecipeError extends VideoRecipeState {
  final String message;

  const VideoRecipeError(this.message);

  @override
  List<Object?> get props => [message];
} 