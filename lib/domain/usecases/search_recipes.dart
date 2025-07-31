import 'package:dartz/dartz.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class SearchRecipes {
  final RecipeRepository repository;

  SearchRecipes(this.repository);

  Future<Either<Failure, List<Recipe>>> call(String query) async {
    return await repository.searchRecipesByName(query);
  }
} 