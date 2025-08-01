import 'package:dartz/dartz.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class ToggleFavoriteRecipe {
  final RecipeRepository repository;

  ToggleFavoriteRecipe(this.repository);

  Future<Either<Failure, bool>> call(String recipeId) async {
    return await repository.toggleFavoriteRecipe(recipeId);
  }
} 