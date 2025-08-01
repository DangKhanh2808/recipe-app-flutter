import 'package:equatable/equatable.dart';
import '../../../domain/entities/recipe.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoriteLoaded extends FavoriteState {
  final Map<String, bool> favoriteStatus;
  final List<Recipe> favoriteRecipes;
  final bool isLoading;

  const FavoriteLoaded({
    required this.favoriteStatus,
    required this.favoriteRecipes,
    this.isLoading = false,
  });

  FavoriteLoaded copyWith({
    Map<String, bool>? favoriteStatus,
    List<Recipe>? favoriteRecipes,
    bool? isLoading,
  }) {
    return FavoriteLoaded(
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [favoriteStatus, favoriteRecipes, isLoading];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
} 