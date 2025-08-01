import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeSearchChanged extends HomeEvent {
  final String query;

  const HomeSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class HomeCategorySelected extends HomeEvent {
  final String categoryId;

  const HomeCategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class HomeRefresh extends HomeEvent {
  const HomeRefresh();
}

class HomeLoadMoreRecipes extends HomeEvent {
  const HomeLoadMoreRecipes();
}

class HomeIngredientSelected extends HomeEvent {
  final String ingredientId;

  const HomeIngredientSelected(this.ingredientId);

  @override
  List<Object?> get props => [ingredientId];
} 