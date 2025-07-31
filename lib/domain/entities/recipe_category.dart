import 'package:equatable/equatable.dart';

class RecipeCategory extends Equatable {
  final String id;
  final String name;
  final String imagePath;
  final int recipeCount;

  const RecipeCategory({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.recipeCount,
  });

  @override
  List<Object?> get props => [id, name, imagePath, recipeCount];
}

class RecipeCategoryData {
  static const List<RecipeCategory> categories = [
    RecipeCategory(
      id: 'Beef',
      name: 'Beef',
      imagePath: 'assets/images/category_beef.png',
      recipeCount: 156,
    ),
    RecipeCategory(
      id: 'Chicken',
      name: 'Chicken',
      imagePath: 'assets/images/category_chicken.png',
      recipeCount: 89,
    ),
    RecipeCategory(
      id: 'Dessert',
      name: 'Dessert',
      imagePath: 'assets/images/category_dessert.png',
      recipeCount: 67,
    ),
    RecipeCategory(
      id: 'Lamb',
      name: 'Lamb',
      imagePath: 'assets/images/category_lamb.png',
      recipeCount: 43,
    ),
    RecipeCategory(
      id: 'Miscellaneous',
      name: 'Miscellaneous',
      imagePath: 'assets/images/category_misc.png',
      recipeCount: 78,
    ),
    RecipeCategory(
      id: 'Pasta',
      name: 'Pasta',
      imagePath: 'assets/images/category_pasta.png',
      recipeCount: 92,
    ),
    RecipeCategory(
      id: 'Pork',
      name: 'Pork',
      imagePath: 'assets/images/category_pork.png',
      recipeCount: 65,
    ),
    RecipeCategory(
      id: 'Seafood',
      name: 'Seafood',
      imagePath: 'assets/images/category_seafood.png',
      recipeCount: 54,
    ),
    RecipeCategory(
      id: 'Side',
      name: 'Side',
      imagePath: 'assets/images/category_side.png',
      recipeCount: 38,
    ),
    RecipeCategory(
      id: 'Starter',
      name: 'Starter',
      imagePath: 'assets/images/category_starter.png',
      recipeCount: 45,
    ),
    RecipeCategory(
      id: 'Vegan',
      name: 'Vegan',
      imagePath: 'assets/images/category_vegan.png',
      recipeCount: 32,
    ),
    RecipeCategory(
      id: 'Vegetarian',
      name: 'Vegetarian',
      imagePath: 'assets/images/category_vegetarian.png',
      recipeCount: 28,
    ),
  ];
} 