import 'package:dartz/dartz.dart';
import '../entities/recipe.dart';
import '../entities/recipe_category.dart';
import '../entities/recipe_area.dart';
import '../entities/recipe_ingredient.dart';
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
  Future<Either<Failure, List<RecipeArea>>> getAreas();
  Future<Either<Failure, List<RecipeIngredient>>> getIngredients();
  
  // Favorite methods
  Future<Either<Failure, bool>> toggleFavoriteRecipe(String recipeId);
  Future<Either<Failure, bool>> isFavoriteRecipe(String recipeId);
  Future<Either<Failure, List<Recipe>>> getFavoriteRecipes();
} 