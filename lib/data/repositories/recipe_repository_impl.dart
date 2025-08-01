import 'package:dartz/dartz.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_category.dart';
import '../../domain/entities/recipe_area.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/recipe_remote_data_source.dart';
import '../datasources/recipe_local_data_source.dart';
import '../models/category_model.dart';
import '../models/area_model.dart';
import '../models/ingredient_model.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl(this.remoteDataSource, this.localDataSource);

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
  Future<Either<Failure, List<RecipeCategory>>> getCategories() async {
    try {
      final categoriesData = await remoteDataSource.getCategories();
      final categories = categoriesData
          .map((json) => CategoryModel.fromJson(json).toEntity())
          .toList();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeArea>>> getAreas() async {
    try {
      final areasData = await remoteDataSource.getAreas();
      final areas = areasData
          .map((json) => AreaModel.fromJson(json))
          .toList();
      return Right(areas);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeIngredient>>> getIngredients() async {
    try {
      final ingredientsData = await remoteDataSource.getIngredients();
      final ingredients = ingredientsData
          .map((json) => IngredientModel.fromJson(json))
          .toList();
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteRecipe(String recipeId) async {
    try {
      final isFavorite = await localDataSource.toggleFavoriteRecipe(recipeId);
      
      if (isFavorite) {
        // If we're adding to favorites, we need to get the recipe data first
        final recipeResult = await getRecipeById(recipeId);
        return recipeResult.fold(
          (failure) => Left(failure),
          (recipe) async {
            try {
              await localDataSource.saveFavoriteRecipe(RecipeModel.fromEntity(recipe));
              return Right(true);
            } catch (e) {
              return Left(CacheFailure(e.toString()));
            }
          },
        );
      } else {
        return Right(false);
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavoriteRecipe(String recipeId) async {
    try {
      final isFavorite = await localDataSource.isFavoriteRecipe(recipeId);
      return Right(isFavorite);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getFavoriteRecipes() async {
    try {
      final recipes = await localDataSource.getFavoriteRecipes();
      return Right(recipes); // RecipeModel extends Recipe, so it's already the entity
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
} 