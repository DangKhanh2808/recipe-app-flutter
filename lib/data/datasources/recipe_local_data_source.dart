import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Future<List<RecipeModel>> getFavoriteRecipes();
  Future<bool> toggleFavoriteRecipe(String recipeId);
  Future<bool> isFavoriteRecipe(String recipeId);
  Future<void> saveFavoriteRecipe(RecipeModel recipe);
  Future<void> removeFavoriteRecipe(String recipeId);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  static const String _favoriteRecipesKey = 'favorite_recipes';
  static const String _favoriteRecipeIdsKey = 'favorite_recipe_ids';

  @override
  Future<List<RecipeModel>> getFavoriteRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recipesJson = prefs.getStringList(_favoriteRecipesKey) ?? [];
      
      return recipesJson
          .map((json) => RecipeModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite recipes: $e');
    }
  }

  @override
  Future<bool> toggleFavoriteRecipe(String recipeId) async {
    try {
      final isFavorite = await isFavoriteRecipe(recipeId);
      
      if (isFavorite) {
        await removeFavoriteRecipe(recipeId);
        return false; // Now not favorite
      } else {
        // Note: We need the full recipe data to save it
        // This will be handled by the repository
        return true; // Now favorite
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite recipe: $e');
    }
  }

  @override
  Future<bool> isFavoriteRecipe(String recipeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList(_favoriteRecipeIdsKey) ?? [];
      return favoriteIds.contains(recipeId);
    } catch (e) {
      throw Exception('Failed to check favorite recipe: $e');
    }
  }

  @override
  Future<void> saveFavoriteRecipe(RecipeModel recipe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save recipe data
      final recipesJson = prefs.getStringList(_favoriteRecipesKey) ?? [];
      recipesJson.add(jsonEncode(recipe.toJson()));
      await prefs.setStringList(_favoriteRecipesKey, recipesJson);
      
      // Save recipe ID for quick lookup
      final favoriteIds = prefs.getStringList(_favoriteRecipeIdsKey) ?? [];
      if (!favoriteIds.contains(recipe.id)) {
        favoriteIds.add(recipe.id);
        await prefs.setStringList(_favoriteRecipeIdsKey, favoriteIds);
      }
    } catch (e) {
      throw Exception('Failed to save favorite recipe: $e');
    }
  }

  @override
  Future<void> removeFavoriteRecipe(String recipeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Remove recipe ID
      final favoriteIds = prefs.getStringList(_favoriteRecipeIdsKey) ?? [];
      favoriteIds.remove(recipeId);
      await prefs.setStringList(_favoriteRecipeIdsKey, favoriteIds);
      
      // Remove recipe data
      final recipesJson = prefs.getStringList(_favoriteRecipesKey) ?? [];
      recipesJson.removeWhere((json) {
        try {
          final recipe = RecipeModel.fromJson(jsonDecode(json));
          return recipe.id == recipeId;
        } catch (e) {
          return false;
        }
      });
      await prefs.setStringList(_favoriteRecipesKey, recipesJson);
    } catch (e) {
      throw Exception('Failed to remove favorite recipe: $e');
    }
  }
} 