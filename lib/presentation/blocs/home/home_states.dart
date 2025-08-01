import 'package:equatable/equatable.dart';
import '../../../domain/entities/recipe.dart';
import '../../../domain/entities/recipe_category.dart';
import '../../../domain/entities/recipe_ingredient.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Recipe> featuredRecipes;
  final List<RecipeCategory> categories;
  final List<RecipeIngredient> ingredients;
  final List<Recipe> recentRecipes;
  final String searchQuery;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? selectedCategoryId;
  final String? selectedIngredientId;

  const HomeLoaded({
    required this.featuredRecipes,
    required this.categories,
    required this.ingredients,
    required this.recentRecipes,
    this.searchQuery = '',
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.selectedCategoryId,
    this.selectedIngredientId,
  });

  @override
  List<Object?> get props => [
    featuredRecipes,
    categories,
    ingredients,
    recentRecipes,
    searchQuery,
    isLoadingMore,
    hasReachedMax,
    selectedCategoryId,
    selectedIngredientId,
  ];

  HomeLoaded copyWith({
    List<Recipe>? featuredRecipes,
    List<RecipeCategory>? categories,
    List<RecipeIngredient>? ingredients,
    List<Recipe>? recentRecipes,
    String? searchQuery,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? selectedCategoryId,
    String? selectedIngredientId,
  }) {
    return HomeLoaded(
      featuredRecipes: featuredRecipes ?? this.featuredRecipes,
      categories: categories ?? this.categories,
      ingredients: ingredients ?? this.ingredients,
      recentRecipes: recentRecipes ?? this.recentRecipes,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedIngredientId: selectedIngredientId ?? this.selectedIngredientId,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
} 