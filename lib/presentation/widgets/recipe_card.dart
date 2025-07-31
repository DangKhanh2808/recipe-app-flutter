import 'package:flutter/material.dart';
import '../../domain/entities/recipe.dart';
import '../../core/constants/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recipe.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                recipe.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: AppColors.neutral200,
                    child: Icon(
                      Icons.restaurant,
                      size: 50,
                      color: AppColors.neutral400,
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                if (recipe.category != null)
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.category!,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                if (recipe.area != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.area!,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
                if (recipe.ingredients.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Ingredients: ${recipe.ingredients.take(3).join(', ')}${recipe.ingredients.length > 3 ? '...' : ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
} 