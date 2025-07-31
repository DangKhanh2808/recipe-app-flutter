import 'package:dartz/dartz.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Recipe>>> getRandomRecipes() async {
    try {
      final recipes = await remoteDataSource.getRandomRecipes();
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeById(String id) async {
    try {
      final recipe = await remoteDataSource.getRecipeById(id);
      return Right(recipe);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> searchRecipesByName(String query) async {
    try {
      final recipes = await remoteDataSource.searchRecipesByName(query);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> searchRecipesByFirstLetter(String letter) async {
    try {
      final recipes = await remoteDataSource.searchRecipesByFirstLetter(letter);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByCategory(String category) async {
    try {
      final recipes = await remoteDataSource.getRecipesByCategory(category);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByArea(String area) async {
    try {
      final recipes = await remoteDataSource.getRecipesByArea(area);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesByIngredient(String ingredient) async {
    try {
      final recipes = await remoteDataSource.getRecipesByIngredient(ingredient);
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreas() async {
    try {
      final areas = await remoteDataSource.getAreas();
      return Right(areas);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getIngredients() async {
    try {
      final ingredients = await remoteDataSource.getIngredients();
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
} 