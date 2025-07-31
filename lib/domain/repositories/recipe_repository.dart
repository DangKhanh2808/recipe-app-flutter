import 'package:dartz/dartz.dart';
import '../entities/recipe.dart';
import '../entities/recipe_category.dart';
import '../../core/errors/failures.dart';

abstract class RecipeRepository {
  Future<Either<Failure, List<Recipe>>> getRandomRecipes();
  Future<Either<Failure, Recipe>> getRecipeById(String id);
  Future<Either<Failure, List<Recipe>>> searchRecipesByName(String query);
  Future<Either<Failure, List<Recipe>>> searchRecipesByFirstLetter(String letter);
  Future<Either<Failure, List<Recipe>>> getRecipesByCategory(String category);
  Future<Either<Failure, List<Recipe>>> getRecipesByArea(String area);
  Future<Either<Failure, List<Recipe>>> getRecipesByIngredient(String ingredient);
  Future<Either<Failure, List<RecipeCategory>>> getCategories();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreas();
  Future<Either<Failure, List<Map<String, dynamic>>>> getIngredients();
} 