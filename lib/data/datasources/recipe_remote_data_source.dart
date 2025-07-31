import 'package:dio/dio.dart';
import '../models/recipe_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';

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
  static const int _maxRecipes = 10;
  static const int _timeoutSeconds = 10;

  RecipeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RecipeModel>> getRandomRecipes() async {
    try {
      final recipes = <RecipeModel>[];
      
      // Get initial random recipe
      final randomRecipe = await _getSingleRandomRecipe();
      if (randomRecipe != null) {
        recipes.add(randomRecipe);
      }
      
      // Get more recipes from popular categories
      if (recipes.isNotEmpty) {
        final moreRecipes = await _getRecipesFromPopularCategories();
        recipes.addAll(moreRecipes);
      }
      
      return recipes.take(_maxRecipes).toList();
    } catch (e) {
      throw ServerFailure('Failed to load recipes: $e');
    }
  }

  Future<RecipeModel?> _getSingleRandomRecipe() async {
    try {
      final response = await dio.get(
        AppConstants.randomMeal,
        options: Options(
          sendTimeout: Duration(seconds: _timeoutSeconds),
          receiveTimeout: Duration(seconds: _timeoutSeconds),
        ),
      );
      
      return _parseMealFromResponse(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<RecipeModel>> _getRecipesFromPopularCategories() async {
    final recipes = <RecipeModel>[];
    final popularCategories = ['Chicken', 'Beef', 'Seafood', 'Vegetarian'];
    
    for (final category in popularCategories) {
      if (recipes.length >= _maxRecipes) break;
      
      try {
        final categoryRecipes = await _getRecipesFromCategory(category, limit: 3);
        recipes.addAll(categoryRecipes);
      } catch (e) {
        print('Error getting recipes from category $category: $e');
        continue;
      }
    }
    
    return recipes;
  }

  Future<List<RecipeModel>> _getRecipesFromCategory(String category, {int limit = 3}) async {
    try {
      final response = await dio.get(
        '${AppConstants.filterByCategory}$category',
        options: Options(
          sendTimeout: Duration(seconds: _timeoutSeconds),
          receiveTimeout: Duration(seconds: _timeoutSeconds),
        ),
      );
      
      final meals = _parseMealsListFromResponse(response.data);
      final recipes = <RecipeModel>[];
      
      for (final meal in meals.take(limit)) {
        final recipeId = meal['idMeal'];
        if (recipeId != null) {
          try {
            final fullRecipe = await getRecipeById(recipeId);
            recipes.add(fullRecipe);
          } catch (e) {
            print('Error getting full recipe for ID $recipeId: $e');
            continue;
          }
        }
      }
      
      return recipes;
    } catch (e) {
      throw ServerFailure('Failed to get recipes from category $category: $e');
    }
  }

  // Helper methods for parsing responses
  RecipeModel? _parseMealFromResponse(Map<String, dynamic> data) {
    if (data['meals'] != null && data['meals'].isNotEmpty) {
      return RecipeModel.fromJson(data['meals'][0]);
    }
    return null;
  }

  List<Map<String, dynamic>> _parseMealsListFromResponse(Map<String, dynamic> data) {
    if (data['meals'] != null) {
      return (data['meals'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  @override
  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final response = await dio.get(
        '${AppConstants.lookupById}$id',
        options: Options(
          sendTimeout: Duration(seconds: _timeoutSeconds),
          receiveTimeout: Duration(seconds: _timeoutSeconds),
        ),
      );
      
      final recipe = _parseMealFromResponse(response.data);
      if (recipe != null) {
        return recipe;
      }
      throw ServerFailure('Recipe not found');
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure('Failed to load recipe: $e');
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipesByName(String query) async {
    return _searchRecipes('${AppConstants.searchByName}$query', 'name');
  }

  @override
  Future<List<RecipeModel>> searchRecipesByFirstLetter(String letter) async {
    return _searchRecipes('${AppConstants.searchByFirstLetter}$letter', 'letter');
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    return _searchRecipes('${AppConstants.filterByCategory}$category', 'category');
  }

  @override
  Future<List<RecipeModel>> getRecipesByArea(String area) async {
    return _searchRecipes('${AppConstants.filterByArea}$area', 'area');
  }

  @override
  Future<List<RecipeModel>> getRecipesByIngredient(String ingredient) async {
    return _searchRecipes('${AppConstants.filterByIngredient}$ingredient', 'ingredient');
  }

  Future<List<RecipeModel>> _searchRecipes(String endpoint, String searchType) async {
    try {
      final response = await dio.get(
        endpoint,
        options: Options(
          sendTimeout: Duration(seconds: _timeoutSeconds),
          receiveTimeout: Duration(seconds: _timeoutSeconds),
        ),
      );
      
      final meals = _parseMealsListFromResponse(response.data);
      return meals.map((json) => RecipeModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure('Failed to search recipes by $searchType: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    return _getListData(AppConstants.listCategories, 'meals', 'categories');
  }

  @override
  Future<List<Map<String, dynamic>>> getAreas() async {
    return _getListData(AppConstants.listAreas, 'meals', 'areas');
  }

  @override
  Future<List<Map<String, dynamic>>> getIngredients() async {
    return _getListData(AppConstants.listIngredients, 'meals', 'ingredients');
  }

  Future<List<Map<String, dynamic>>> _getListData(String endpoint, String dataKey, String dataType) async {
    try {
      final response = await dio.get(
        endpoint,
        options: Options(
          sendTimeout: Duration(seconds: _timeoutSeconds),
          receiveTimeout: Duration(seconds: _timeoutSeconds),
        ),
      );
      
      if (response.data[dataKey] != null) {
        final data = (response.data[dataKey] as List).cast<Map<String, dynamic>>();
        return data;
      }
      return [];
    } catch (e) {
      throw ServerFailure('Failed to load $dataType: $e');
    }
  }
} 