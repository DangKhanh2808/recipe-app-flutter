import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../blocs/filter/filter_bloc.dart';
import '../../blocs/filter/filter_events.dart';
import '../../blocs/filter/filter_states.dart';

class FilterBottomSheet extends StatelessWidget {
  final Function(Map<String, String?>)? onFiltersApplied;
  
  const FilterBottomSheet({Key? key, this.onFiltersApplied}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FilterBloc>()..add(const FilterLoadData()),
      child: FilterBottomSheetView(onFiltersApplied: onFiltersApplied),
    );
  }
}

class FilterBottomSheetView extends StatelessWidget {
  final Function(Map<String, String?>)? onFiltersApplied;
  
  const FilterBottomSheetView({Key? key, this.onFiltersApplied}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Close Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
                
                // Title
                const Expanded(
                  child: Text(
                    'Lọc',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                
                // Reset Button
                TextButton(
                  onPressed: () {
                    context.read<FilterBloc>().add(const FilterReset());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(
                        color: AppColors.primary600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filter Content
          Expanded(
            child: BlocBuilder<FilterBloc, FilterState>(
              builder: (context, state) {
                if (state is FilterLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FilterLoaded) {
                  return _buildFilterContent(context, state);
                } else if (state is FilterError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          
          // Apply Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                final currentState = context.read<FilterBloc>().state;
                if (currentState is FilterLoaded) {
                  final filters = {
                    'category': currentState.selectedCategory,
                    'ingredient': currentState.selectedIngredient,
                    'area': currentState.selectedArea,
                  };
                  onFiltersApplied?.call(filters);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent(BuildContext context, FilterLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Section
          _buildFilterSection(
            context,
            title: 'Danh mục',
            icon: Icons.category,
            items: state.categories,
            selectedItem: state.selectedCategory,
            onItemSelected: (category) {
              context.read<FilterBloc>().add(FilterCategorySelected(category));
            },
          ),
          
          const SizedBox(height: 24),
          
          // Ingredients Section
          _buildFilterSection(
            context,
            title: 'Nguyên liệu',
            icon: Icons.restaurant,
            items: state.ingredients,
            selectedItem: state.selectedIngredient,
            onItemSelected: (ingredient) {
              context.read<FilterBloc>().add(FilterIngredientSelected(ingredient));
            },
          ),
          
          const SizedBox(height: 24),
          
          // Areas Section
          _buildFilterSection(
            context,
            title: 'Khu vực',
            icon: Icons.location_on,
            items: state.areas,
            selectedItem: state.selectedArea,
            onItemSelected: (area) {
              context.read<FilterBloc>().add(FilterAreaSelected(area));
            },
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> items,
    required String? selectedItem,
    required Function(String) onItemSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Filter Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedItem == item;
            return GestureDetector(
              onTap: () => onItemSelected(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary500 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary500 : AppColors.neutral300,
                    width: 1,
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
} 