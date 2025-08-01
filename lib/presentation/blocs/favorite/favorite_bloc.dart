import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/toggle_favorite_recipe.dart';
import '../../../domain/usecases/check_favorite_recipe.dart';
import '../../../domain/usecases/get_favorite_recipes.dart';
import '../../../core/errors/failures.dart';
import 'favorite_events.dart';
import 'favorite_states.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final ToggleFavoriteRecipe _toggleFavoriteRecipe;
  final CheckFavoriteRecipe _checkFavoriteRecipe;
  final GetFavoriteRecipes _getFavoriteRecipes;

  FavoriteBloc({
    required ToggleFavoriteRecipe toggleFavoriteRecipe,
    required CheckFavoriteRecipe checkFavoriteRecipe,
    required GetFavoriteRecipes getFavoriteRecipes,
  })  : _toggleFavoriteRecipe = toggleFavoriteRecipe,
        _checkFavoriteRecipe = checkFavoriteRecipe,
        _getFavoriteRecipes = getFavoriteRecipes,
        super(const FavoriteInitial()) {
    on<ToggleFavorite>(_onToggleFavorite);
    on<CheckFavorite>(_onCheckFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  void _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      emit(currentState.copyWith(isLoading: true));

      try {
        final result = await _toggleFavoriteRecipe(event.recipeId);
        
        if (!emit.isDone) {
          result.fold(
            (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
            (isFavorite) {
              final updatedStatus = Map<String, bool>.from(currentState.favoriteStatus);
              updatedStatus[event.recipeId] = isFavorite;
              
              emit(currentState.copyWith(
                favoriteStatus: updatedStatus,
                isLoading: false,
              ));
            },
          );
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(FavoriteError(e.toString()));
        }
      }
    }
  }

  void _onCheckFavorite(
    CheckFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final result = await _checkFavoriteRecipe(event.recipeId);
      
      if (!emit.isDone) {
        result.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (isFavorite) {
            if (state is FavoriteLoaded) {
              final currentState = state as FavoriteLoaded;
              final updatedStatus = Map<String, bool>.from(currentState.favoriteStatus);
              updatedStatus[event.recipeId] = isFavorite;
              
              emit(currentState.copyWith(favoriteStatus: updatedStatus));
            } else {
              emit(FavoriteLoaded(
                favoriteStatus: {event.recipeId: isFavorite},
                favoriteRecipes: [],
              ));
            }
          },
        );
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(FavoriteError(e.toString()));
      }
    }
  }

  void _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(const FavoriteLoading());

    try {
      final result = await _getFavoriteRecipes();
      
      if (!emit.isDone) {
        result.fold(
          (failure) => emit(FavoriteError(_mapFailureToMessage(failure))),
          (favoriteRecipes) {
            final favoriteStatus = <String, bool>{};
            for (final recipe in favoriteRecipes) {
              favoriteStatus[recipe.id] = true;
            }
            
            emit(FavoriteLoaded(
              favoriteStatus: favoriteStatus,
              favoriteRecipes: favoriteRecipes,
            ));
          },
        );
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(FavoriteError(e.toString()));
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Lỗi máy chủ: ${failure.message}';
      case NetworkFailure:
        return 'Lỗi kết nối mạng: ${failure.message}';
      case CacheFailure:
        return 'Lỗi cache: ${failure.message}';
      default:
        return 'Lỗi không xác định: ${failure.message}';
    }
  }
} 