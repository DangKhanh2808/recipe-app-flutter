import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class ToggleFavorite extends FavoriteEvent {
  final String recipeId;

  const ToggleFavorite(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class CheckFavorite extends FavoriteEvent {
  final String recipeId;

  const CheckFavorite(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class LoadFavorites extends FavoriteEvent {
  const LoadFavorites();
} 