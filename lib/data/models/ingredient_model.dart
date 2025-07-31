import '../../domain/entities/recipe_ingredient.dart';

class IngredientModel extends RecipeIngredient {
  const IngredientModel({required String name}) : super(name: name);

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(name: json['strIngredient'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'strIngredient': name};
  }
} 