import 'package:equatable/equatable.dart';
import '../../../domain/entities/recipe.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchSuggestions extends SearchState {
  final List<String> suggestions;

  const SearchSuggestions(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class SearchResults extends SearchState {
  final List<Recipe> recipes;

  const SearchResults(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
} 