import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_events.dart';
import 'home_states.dart';
import '../../../domain/entities/recipe.dart';
import '../../../domain/entities/recipe_category.dart';
import '../../../domain/usecases/get_recipes.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../core/errors/failures.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetRandomRecipes getRandomRecipes;
  final GetRecipesByCategory getRecipesByCategory;
  final GetCategories getCategories;

  HomeBloc({
    required this.getRandomRecipes,
    required this.getRecipesByCategory,
    required this.getCategories,
  }) : super(const HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeSearchChanged>(_onHomeSearchChanged);
    on<HomeCategorySelected>(_onHomeCategorySelected);
    on<HomeRefresh>(_onHomeRefresh);
    on<HomeLoadMoreRecipes>(_onHomeLoadMoreRecipes);
  }

  void _onHomeStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    
    try {
      // Get random recipes for featured section
      final featuredResult = await getRandomRecipes(NoParams());
      
      // Get recipes from popular categories for recent section
      final recentResult = await getRecipesByCategory('Beef');
      
      // Get categories from API
      final categoriesResult = await getCategories();
      
      if (featuredResult.isRight() && recentResult.isRight() && categoriesResult.isRight()) {
        final featuredRecipes = featuredResult.getOrElse(() => []);
        final recentRecipes = recentResult.getOrElse(() => []);
        final categories = categoriesResult.getOrElse(() => []);
        
        emit(HomeLoaded(
          featuredRecipes: featuredRecipes,
          categories: categories,
          recentRecipes: recentRecipes,
        ));
      } else {
        final failure = featuredResult.isLeft() 
            ? featuredResult.fold((l) => l, (r) => ServerFailure('Failed to load featured recipes'))
            : recentResult.isLeft()
                ? recentResult.fold((l) => l, (r) => ServerFailure('Failed to load recent recipes'))
                : categoriesResult.fold((l) => l, (r) => ServerFailure('Failed to load categories'));
        
        emit(HomeError(_mapFailureToMessage(failure)));
      }
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
    }
  }

  void _onHomeSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  void _onHomeCategorySelected(HomeCategorySelected event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
      
      try {
        // Find category name by ID
        final selectedCategory = currentState.categories.firstWhere(
          (category) => category.id == event.categoryId,
          orElse: () => const RecipeCategory(id: '', name: '', imagePath: '', recipeCount: 0),
        );
        
        if (selectedCategory.id.isNotEmpty) {
          // Load recipes for selected category
          final result = await getRecipesByCategory(selectedCategory.name);
          
          if (result.isRight()) {
            final categoryRecipes = result.getOrElse(() => []);
            emit(currentState.copyWith(
              recentRecipes: categoryRecipes,
              selectedCategoryId: event.categoryId,
              isLoadingMore: false,
            ));
          } else {
            emit(currentState.copyWith(isLoadingMore: false));
          }
        } else {
          emit(currentState.copyWith(isLoadingMore: false));
        }
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  void _onHomeRefresh(HomeRefresh event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
      
      try {
        final result = await getRandomRecipes(NoParams());
        if (result.isRight()) {
          final newRecipes = result.getOrElse(() => []);
          emit(currentState.copyWith(
            recentRecipes: [...currentState.recentRecipes, ...newRecipes],
            isLoadingMore: false,
          ));
        } else {
          emit(currentState.copyWith(isLoadingMore: false));
        }
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  void _onHomeLoadMoreRecipes(HomeLoadMoreRecipes event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      if (!currentState.isLoadingMore && !currentState.hasReachedMax) {
        emit(currentState.copyWith(isLoadingMore: true));
        
        try {
          final result = await getRandomRecipes(NoParams());
          if (result.isRight()) {
            final moreRecipes = result.getOrElse(() => []);
            emit(currentState.copyWith(
              recentRecipes: [...currentState.recentRecipes, ...moreRecipes],
              isLoadingMore: false,
              hasReachedMax: currentState.recentRecipes.length > 20, // Limit for demo
            ));
          } else {
            emit(currentState.copyWith(isLoadingMore: false));
          }
        } catch (e) {
          emit(currentState.copyWith(isLoadingMore: false));
        }
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again.';
      case NetworkFailure:
        return 'Network error. Please check your connection.';
      case CacheFailure:
        return 'Cache error occurred.';
      default:
        return 'Unexpected error occurred.';
    }
  }


} 