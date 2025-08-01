import 'package:equatable/equatable.dart';

abstract class RecipeDetailEvent extends Equatable {
  const RecipeDetailEvent();

  @override
  List<Object?> get props => [];
}

class RecipeDetailStarted extends RecipeDetailEvent {
  final String recipeId;

  const RecipeDetailStarted(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class RecipeDetailToggleFavorite extends RecipeDetailEvent {
  final String recipeId;

  const RecipeDetailToggleFavorite(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class RecipeDetailRefresh extends RecipeDetailEvent {
  final String recipeId;

  const RecipeDetailRefresh(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
} 