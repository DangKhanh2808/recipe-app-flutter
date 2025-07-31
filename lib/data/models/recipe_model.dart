import '../../domain/entities/recipe.dart';
import '../../core/utils/recipe_parser.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    super.category,
    super.area,
    super.instructions,
    super.imageUrl,
    super.tags,
    super.youtube,
    required super.ingredients,
    required super.measures,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    // Handle TheMealDB API response format
    if (json.containsKey('idMeal')) {
      // This is a TheMealDB meal object
      final parsedData = RecipeParser.parseMealToRecipe(json);
      return RecipeModel(
        id: parsedData['id'],
        name: parsedData['name'],
        category: parsedData['category'],
        area: parsedData['area'],
        instructions: parsedData['instructions'],
        imageUrl: parsedData['imageUrl'],
        tags: parsedData['tags'],
        youtube: parsedData['youtube'],
        ingredients: List<String>.from(parsedData['ingredients']),
        measures: List<String>.from(parsedData['measures']),
      );
    } else {
      // This is a regular JSON object
      return RecipeModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        category: json['category'],
        area: json['area'],
        instructions: json['instructions'],
        imageUrl: json['imageUrl'],
        tags: json['tags'],
        youtube: json['youtube'],
        ingredients: List<String>.from(json['ingredients'] ?? []),
        measures: List<String>.from(json['measures'] ?? []),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'area': area,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'tags': tags,
      'youtube': youtube,
      'ingredients': ingredients,
      'measures': measures,
    };
  }

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id,
      name: recipe.name,
      category: recipe.category,
      area: recipe.area,
      instructions: recipe.instructions,
      imageUrl: recipe.imageUrl,
      tags: recipe.tags,
      youtube: recipe.youtube,
      ingredients: recipe.ingredients,
      measures: recipe.measures,
    );
  }
} 