import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_recipes.dart';
import '../../core/errors/failures.dart';

// Events
abstract class RecipeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class SearchRecipes extends RecipeEvent {
  final String query;

  SearchRecipes(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class RecipeState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRandomRecipes getRandomRecipes;
  final SearchRecipesByName searchRecipesByName;

  RecipeBloc({
    required this.getRandomRecipes,
    required this.searchRecipesByName,
  }) : super(RecipeInitial()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<SearchRecipes>(_onSearchRecipes);
  }

  Future<void> _onLoadRecipes(LoadRecipes event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    
    final result = await getRandomRecipes(NoParams());
    
    result.fold(
      (failure) => emit(RecipeError(_mapFailureToMessage(failure))),
      (recipes) => emit(RecipeLoaded(recipes)),
    );
  }

  Future<void> _onSearchRecipes(SearchRecipes event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    
    final result = await searchRecipesByName(event.query);
    
    result.fold(
      (failure) => emit(RecipeError(_mapFailureToMessage(failure))),
      (recipes) => emit(RecipeLoaded(recipes)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case NetworkFailure:
        return 'Network error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      default:
        return 'Unknown error occurred';
    }
  }
} 