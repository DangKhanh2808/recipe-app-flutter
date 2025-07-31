import 'package:equatable/equatable.dart';
import '../../../domain/entities/recipe.dart';
import '../../../domain/entities/recipe_category.dart';

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
  final List<Recipe> recentRecipes;
  final String searchQuery;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const HomeLoaded({
    required this.featuredRecipes,
    required this.categories,
    required this.recentRecipes,
    this.searchQuery = '',
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
    featuredRecipes,
    categories,
    recentRecipes,
    searchQuery,
    isLoadingMore,
    hasReachedMax,
  ];

  HomeLoaded copyWith({
    List<Recipe>? featuredRecipes,
    List<RecipeCategory>? categories,
    List<Recipe>? recentRecipes,
    String? searchQuery,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return HomeLoaded(
      featuredRecipes: featuredRecipes ?? this.featuredRecipes,
      categories: categories ?? this.categories,
      recentRecipes: recentRecipes ?? this.recentRecipes,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
} 