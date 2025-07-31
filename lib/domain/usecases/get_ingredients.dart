import 'package:dartz/dartz.dart';
import '../entities/recipe_ingredient.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class GetIngredients {
  final RecipeRepository repository;

  GetIngredients(this.repository);

  Future<Either<Failure, List<RecipeIngredient>>> call() async {
    return await repository.getIngredients();
  }
} 