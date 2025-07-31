import 'package:dio/dio.dart';
import '../models/recipe_model.dart';
import '../../core/constants/app_constants.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRandomRecipes();
  Future<RecipeModel> getRecipeById(String id);
  Future<List<RecipeModel>> searchRecipesByName(String query);
  Future<List<RecipeModel>> searchRecipesByFirstLetter(String letter);
  Future<List<RecipeModel>> getRecipesByCategory(String category);
  Future<List<RecipeModel>> getRecipesByArea(String area);
  Future<List<RecipeModel>> getRecipesByIngredient(String ingredient);
  Future<List<Map<String, dynamic>>> getCategories();
  Future<List<Map<String, dynamic>>> getAreas();
  Future<List<Map<String, dynamic>>> getIngredients();
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;

  RecipeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RecipeModel>> getRandomRecipes() async {
    try {
      // Get 10 random recipes by calling random endpoint multiple times
      List<RecipeModel> recipes = [];
      for (int i = 0; i < 10; i++) {
        final response = await dio.get(AppConstants.randomMeal);
        if (response.data['meals'] != null && response.data['meals'].isNotEmpty) {
          final meal = response.data['meals'][0];
          recipes.add(RecipeModel.fromJson(meal));
        }
      }
      return recipes;
    } catch (e) {
      throw Exception('Failed to load random recipes: $e');
    }
  }

  @override
  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final response = await dio.get('${AppConstants.lookupById}$id');
      if (response.data['meals'] != null && response.data['meals'].isNotEmpty) {
        return RecipeModel.fromJson(response.data['meals'][0]);
      }
      throw Exception('Recipe not found');
    } catch (e) {
      throw Exception('Failed to load recipe: $e');
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipesByName(String query) async {
    try {
      final response = await dio.get('${AppConstants.searchByName}$query');
      if (response.data['meals'] != null) {
        return (response.data['meals'] as List)
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search recipes: $e');
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipesByFirstLetter(String letter) async {
    try {
      final response = await dio.get('${AppConstants.searchByFirstLetter}$letter');
      if (response.data['meals'] != null) {
        return (response.data['meals'] as List)
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search recipes by letter: $e');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    try {
      final response = await dio.get('${AppConstants.filterByCategory}$category');
      if (response.data['meals'] != null) {
        return (response.data['meals'] as List)
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load recipes by category: $e');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByArea(String area) async {
    try {
      final response = await dio.get('${AppConstants.filterByArea}$area');
      if (response.data['meals'] != null) {
        return (response.data['meals'] as List)
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load recipes by area: $e');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByIngredient(String ingredient) async {
    try {
      final response = await dio.get('${AppConstants.filterByIngredient}$ingredient');
      if (response.data['meals'] != null) {
        return (response.data['meals'] as List)
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load recipes by ingredient: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await dio.get(AppConstants.categories);
      if (response.data['categories'] != null) {
        return (response.data['categories'] as List).cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAreas() async {
    try {
      final response = await dio.get(AppConstants.listAreas);
      if (response.data['meals'] != null) {
        return (response.data['meals'] as List).cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load areas: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getIngredients() async {
    try {
      final response = await dio.get(AppConstants.listIngredients);
      if (response.data['meals'] != null) {
        return (response.data['meals'] as List).cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load ingredients: $e');
    }
  }
} 