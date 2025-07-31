import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class GetRandomRecipes implements UseCase<List<Recipe>, NoParams> {
  final RecipeRepository repository;

  GetRandomRecipes(this.repository);

  @override
  Future<Either<Failure, List<Recipe>>> call(NoParams params) async {
    return await repository.getRandomRecipes();
  }
}

class SearchRecipesByName implements UseCase<List<Recipe>, String> {
  final RecipeRepository repository;

  SearchRecipesByName(this.repository);

  @override
  Future<Either<Failure, List<Recipe>>> call(String query) async {
    return await repository.searchRecipesByName(query);
  }
}

class GetRecipesByCategory implements UseCase<List<Recipe>, String> {
  final RecipeRepository repository;

  GetRecipesByCategory(this.repository);

  @override
  Future<Either<Failure, List<Recipe>>> call(String category) async {
    return await repository.getRecipesByCategory(category);
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
} 