import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class FilterCategorySelected extends FilterEvent {
  final String category;

  const FilterCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterIngredientSelected extends FilterEvent {
  final String ingredient;

  const FilterIngredientSelected(this.ingredient);

  @override
  List<Object?> get props => [ingredient];
}

class FilterAreaSelected extends FilterEvent {
  final String area;

  const FilterAreaSelected(this.area);

  @override
  List<Object?> get props => [area];
}

class FilterReset extends FilterEvent {
  const FilterReset();
}

class FilterApply extends FilterEvent {
  const FilterApply();
}

class FilterLoadData extends FilterEvent {
  const FilterLoadData();
} 