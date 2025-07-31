import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FavoriteRecipesGrid extends StatelessWidget {
  final List<String> recipeImages;
  final VoidCallback? onRecipeTap;

  const FavoriteRecipesGrid({
    Key? key,
    required this.recipeImages,
    this.onRecipeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Text(
            'Danh sách yêu thích',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        
        // Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: recipeImages.length,
            itemBuilder: (context, index) {
              return _buildRecipeItem(recipeImages[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeItem(String imageUrl) {
    return GestureDetector(
      onTap: onRecipeTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.neutral200,
                ),
                child: const Icon(
                  Icons.restaurant,
                  size: 30,
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
} 