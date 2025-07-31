import 'package:equatable/equatable.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

class FilterInitial extends FilterState {
  const FilterInitial();
}

class FilterLoading extends FilterState {
  const FilterLoading();
}

class FilterLoaded extends FilterState {
  final List<String> categories;
  final List<String> ingredients;
  final List<String> areas;
  final String? selectedCategory;
  final String? selectedIngredient;
  final String? selectedArea;

  const FilterLoaded({
    required this.categories,
    required this.ingredients,
    required this.areas,
    this.selectedCategory,
    this.selectedIngredient,
    this.selectedArea,
  });

  @override
  List<Object?> get props => [
    categories,
    ingredients,
    areas,
    selectedCategory,
    selectedIngredient,
    selectedArea,
  ];

  FilterLoaded copyWith({
    List<String>? categories,
    List<String>? ingredients,
    List<String>? areas,
    String? selectedCategory,
    String? selectedIngredient,
    String? selectedArea,
  }) {
    return FilterLoaded(
      categories: categories ?? this.categories,
      ingredients: ingredients ?? this.ingredients,
      areas: areas ?? this.areas,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedIngredient: selectedIngredient ?? this.selectedIngredient,
      selectedArea: selectedArea ?? this.selectedArea,
    );
  }
}

class FilterError extends FilterState {
  final String message;

  const FilterError(this.message);

  @override
  List<Object?> get props => [message];
} 