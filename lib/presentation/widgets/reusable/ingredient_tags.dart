import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/recipe_ingredient.dart';

class IngredientTags extends StatelessWidget {
  final List<RecipeIngredient> ingredients;
  final String? selectedIngredientId;
  final Function(String) onIngredientSelected;
  final int maxItems;

  const IngredientTags({
    Key? key,
    required this.ingredients,
    this.selectedIngredientId,
    required this.onIngredientSelected,
    this.maxItems = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Nguyên liệu',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 15),
          
          // Ingredients tags
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ingredients.take(maxItems).map((ingredient) {
              final isSelected = selectedIngredientId == ingredient.name;
              return _buildIngredientTag(
                ingredient.name,
                isSelected,
                onTap: () => onIngredientSelected(ingredient.name),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientTag(String text, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD700) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
} 