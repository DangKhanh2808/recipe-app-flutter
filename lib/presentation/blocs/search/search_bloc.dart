import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_events.dart';
import 'search_states.dart';
import '../../../domain/usecases/search_recipes.dart';
import '../../../domain/entities/recipe.dart';
import '../../../core/errors/failures.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  Timer? _debounceTimer;
  final SearchRecipes _searchRecipes;
  
  // Popular search terms for suggestions
  final List<String> _popularSearches = [
    'Chicken',
    'Beef',
    'Pizza',
    'Seafood',
    'Dessert',
    'Vegetarian',
  ];

  SearchBloc(this._searchRecipes) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchCleared>(_onSearchCleared);
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!emit.isDone) {
        final suggestions = _getSuggestions(event.query);
        emit(SearchSuggestions(suggestions));
      }
    });
  }

  void _onSearchSubmitted(SearchSubmitted event, Emitter<SearchState> emit) async {
    _debounceTimer?.cancel();
    
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());
    
    final result = await _searchRecipes.call(event.query);
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(SearchError(_mapFailureToMessage(failure))),
        (recipes) => emit(SearchResults(recipes)),
      );
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    emit(const SearchInitial());
  }

  List<String> _getSuggestions(String query) {
    if (query.isEmpty) return [];
    
    final lowercaseQuery = query.toLowerCase();
    return _popularSearches
        .where((term) => term.toLowerCase().contains(lowercaseQuery))
        .take(5)
        .toList();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Lỗi server, vui lòng thử lại sau';
      case NetworkFailure:
        return 'Lỗi kết nối mạng';
      case CacheFailure:
        return 'Lỗi cache';
      default:
        return 'Có lỗi xảy ra';
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
} 