class RecipeParser {
  static List<String> parseIngredients(Map<String, dynamic> meal) {
    List<String> ingredients = [];
    
    for (int i = 1; i <= 20; i++) {
      String ingredient = meal['strIngredient$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
      }
    }
    
    return ingredients;
  }

  static List<String> parseMeasures(Map<String, dynamic> meal) {
    List<String> measures = [];
    
    for (int i = 1; i <= 20; i++) {
      String measure = meal['strMeasure$i'];
      if (measure != null && measure.isNotEmpty) {
        measures.add(measure);
      }
    }
    
    return measures;
  }

  static Map<String, dynamic> parseMealToRecipe(Map<String, dynamic> meal) {
    List<String> ingredients = parseIngredients(meal);
    List<String> measures = parseMeasures(meal);
    
    return {
      'id': meal['idMeal'] ?? '',
      'name': meal['strMeal'] ?? '',
      'category': meal['strCategory'],
      'area': meal['strArea'],
      'instructions': meal['strInstructions'],
      'imageUrl': meal['strMealThumb'],
      'tags': meal['strTags'],
      'youtube': meal['strYoutube'],
      'ingredients': ingredients,
      'measures': measures,
    };
  }
} 