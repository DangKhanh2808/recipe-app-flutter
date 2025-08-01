import 'package:dartz/dartz.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class GetFavoriteRecipes {
  final RecipeRepository repository;

  GetFavoriteRecipes(this.repository);

  Future<Either<Failure, List<Recipe>>> call() async {
    return await repository.getFavoriteRecipes();
  }
} 