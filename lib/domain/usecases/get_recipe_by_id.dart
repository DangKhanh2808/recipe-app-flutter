import 'package:dartz/dartz.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class GetRecipeById {
  final RecipeRepository repository;

  GetRecipeById(this.repository);

  Future<Either<Failure, Recipe>> call(String id) async {
    return await repository.getRecipeById(id);
  }
} 