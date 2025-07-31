import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/domain/entities/recipe_category.dart';


class CategoryCard extends StatelessWidget {
  final RecipeCategory category;
  final VoidCallback? onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Image placeholder
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(category.name),
                  size: 40,
                  color: AppColors.primary500,
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'beef':
        return Icons.restaurant;
      case 'chicken':
        return Icons.egg;
      case 'dessert':
        return Icons.cake;
      case 'lamb':
        return Icons.restaurant_menu;
      case 'miscellaneous':
        return Icons.more_horiz;
      case 'pasta':
        return Icons.ramen_dining;
      case 'pork':
        return Icons.restaurant;
      case 'seafood':
        return Icons.set_meal;
      case 'side':
        return Icons.menu_book;
      case 'starter':
        return Icons.tapas;
      case 'vegan':
        return Icons.eco;
      case 'vegetarian':
        return Icons.eco;
      default:
        return Icons.fastfood;
    }
  }
} 