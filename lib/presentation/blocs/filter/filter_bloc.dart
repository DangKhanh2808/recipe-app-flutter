import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_events.dart';
import 'filter_states.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_areas.dart';
import '../../../domain/usecases/get_ingredients.dart';
import '../../../core/errors/failures.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final GetCategories _getCategories;
  final GetAreas _getAreas;
  final GetIngredients _getIngredients;

  FilterBloc({
    required GetCategories getCategories,
    required GetAreas getAreas,
    required GetIngredients getIngredients,
  }) : _getCategories = getCategories,
       _getAreas = getAreas,
       _getIngredients = getIngredients,
       super(const FilterInitial()) {
    on<FilterLoadData>(_onFilterLoadData);
    on<FilterCategorySelected>(_onFilterCategorySelected);
    on<FilterIngredientSelected>(_onFilterIngredientSelected);
    on<FilterAreaSelected>(_onFilterAreaSelected);
    on<FilterReset>(_onFilterReset);
    on<FilterApply>(_onFilterApply);
  }

  void _onFilterLoadData(FilterLoadData event, Emitter<FilterState> emit) async {
    emit(const FilterLoading());

    try {
      final categoriesResult = await _getCategories();
      final areasResult = await _getAreas();
      final ingredientsResult = await _getIngredients();

      final categories = categoriesResult.fold(
        (failure) => <String>[],
        (categories) => categories.map((c) => c.name).toList(),
      );

      final areas = areasResult.fold(
        (failure) => <String>[],
        (areas) => areas.map((a) => a.name).toList(),
      );

      final ingredients = ingredientsResult.fold(
        (failure) => <String>[],
        (ingredients) => ingredients.map((i) => i.name).toList(),
      );
      
      emit(FilterLoaded(
        categories: categories,
        ingredients: ingredients,
        areas: areas,
      ));
    } catch (e) {
      emit(FilterError('Có lỗi xảy ra khi tải dữ liệu filter'));
    }
  }

  void _onFilterCategorySelected(FilterCategorySelected event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      final newSelectedCategory = currentState.selectedCategory == event.category 
          ? null 
          : event.category;
      
      emit(currentState.copyWith(selectedCategory: newSelectedCategory));
    }
  }

  void _onFilterIngredientSelected(FilterIngredientSelected event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      final newSelectedIngredient = currentState.selectedIngredient == event.ingredient 
          ? null 
          : event.ingredient;
      
      emit(currentState.copyWith(selectedIngredient: newSelectedIngredient));
    }
  }

  void _onFilterAreaSelected(FilterAreaSelected event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      final newSelectedArea = currentState.selectedArea == event.area 
          ? null 
          : event.area;
      
      emit(currentState.copyWith(selectedArea: newSelectedArea));
    }
  }

  void _onFilterReset(FilterReset event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      emit(currentState.copyWith(
        selectedCategory: null,
        selectedIngredient: null,
        selectedArea: null,
      ));
    }
  }

  void _onFilterApply(FilterApply event, Emitter<FilterState> emit) {
    // Emit the current filter state so parent can access the selected filters
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      emit(currentState); // Re-emit the same state to notify listeners
    }
  }
} 