import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_recipes.dart';
import '../../../domain/usecases/search_recipes.dart';
import '../../../core/errors/failures.dart';
import 'video_recipe_events.dart';
import 'video_recipe_states.dart';

class VideoRecipeBloc extends Bloc<VideoRecipeEvent, VideoRecipeState> {
  final GetRandomRecipes _getRandomRecipes;
  final SearchRecipesByName _searchRecipesByName;

  VideoRecipeBloc({
    required GetRandomRecipes getRandomRecipes,
    required SearchRecipesByName searchRecipesByName,
  })  : _getRandomRecipes = getRandomRecipes,
        _searchRecipesByName = searchRecipesByName,
        super(const VideoRecipeInitial()) {
    on<VideoRecipeStarted>(_onVideoRecipeStarted);
    on<VideoRecipeTabChanged>(_onVideoRecipeTabChanged);
    on<VideoRecipeRefresh>(_onVideoRecipeRefresh);
    on<VideoRecipeLoadMore>(_onVideoRecipeLoadMore);
  }

  void _onVideoRecipeStarted(
    VideoRecipeStarted event,
    Emitter<VideoRecipeState> emit,
  ) async {
    emit(const VideoRecipeLoading());

    try {
      // Load video recipes (random recipes)
      final videoResult = await _getRandomRecipes(NoParams());
      
      // Load recipe recipes (search for popular recipes)
      final recipeResult = await _searchRecipesByName.call('chicken');

      if (!emit.isDone) {
        videoResult.fold(
          (failure) => emit(VideoRecipeError(_mapFailureToMessage(failure))),
          (videoRecipes) {
            recipeResult.fold(
              (failure) => emit(VideoRecipeError(_mapFailureToMessage(failure))),
              (recipeRecipes) => emit(VideoRecipeLoaded(
                videoRecipes: videoRecipes,
                recipeRecipes: recipeRecipes,
                currentTabIndex: 0,
              )),
            );
          },
        );
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(VideoRecipeError(e.toString()));
      }
    }
  }

  void _onVideoRecipeTabChanged(
    VideoRecipeTabChanged event,
    Emitter<VideoRecipeState> emit,
  ) {
    if (state is VideoRecipeLoaded) {
      final currentState = state as VideoRecipeLoaded;
      emit(currentState.copyWith(currentTabIndex: event.tabIndex));
    }
  }

  void _onVideoRecipeRefresh(
    VideoRecipeRefresh event,
    Emitter<VideoRecipeState> emit,
  ) async {
    if (state is VideoRecipeLoaded) {
      final currentState = state as VideoRecipeLoaded;
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        // Refresh current tab data
        if (currentState.currentTabIndex == 0) {
          // Refresh video recipes
          final result = await _getRandomRecipes(NoParams());
          if (!emit.isDone) {
            result.fold(
              (failure) => emit(VideoRecipeError(_mapFailureToMessage(failure))),
              (videoRecipes) => emit(currentState.copyWith(
                videoRecipes: videoRecipes,
                isLoadingMore: false,
              )),
            );
          }
        } else {
          // Refresh recipe recipes
          final result = await _searchRecipesByName.call('chicken');
          if (!emit.isDone) {
            result.fold(
              (failure) => emit(VideoRecipeError(_mapFailureToMessage(failure))),
              (recipeRecipes) => emit(currentState.copyWith(
                recipeRecipes: recipeRecipes,
                isLoadingMore: false,
              )),
            );
          }
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(VideoRecipeError(e.toString()));
        }
      }
    }
  }

  void _onVideoRecipeLoadMore(
    VideoRecipeLoadMore event,
    Emitter<VideoRecipeState> emit,
  ) async {
    if (state is VideoRecipeLoaded) {
      final currentState = state as VideoRecipeLoaded;
      
      if (currentState.isLoadingMore || currentState.hasReachedMax) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        // Load more data for current tab
        if (currentState.currentTabIndex == 0) {
          // Load more video recipes
          final result = await _getRandomRecipes(NoParams());
          if (!emit.isDone) {
            result.fold(
              (failure) => emit(VideoRecipeError(_mapFailureToMessage(failure))),
              (newRecipes) {
                final updatedRecipes = [...currentState.videoRecipes, ...newRecipes];
                emit(currentState.copyWith(
                  videoRecipes: updatedRecipes,
                  isLoadingMore: false,
                  hasReachedMax: updatedRecipes.length >= 20, // Limit to 20 recipes
                ));
              },
            );
          }
        } else {
          // Load more recipe recipes
          final result = await _searchRecipesByName.call('beef');
          if (!emit.isDone) {
            result.fold(
              (failure) => emit(VideoRecipeError(_mapFailureToMessage(failure))),
              (newRecipes) {
                final updatedRecipes = [...currentState.recipeRecipes, ...newRecipes];
                emit(currentState.copyWith(
                  recipeRecipes: updatedRecipes,
                  isLoadingMore: false,
                  hasReachedMax: updatedRecipes.length >= 20, // Limit to 20 recipes
                ));
              },
            );
          }
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(VideoRecipeError(e.toString()));
        }
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