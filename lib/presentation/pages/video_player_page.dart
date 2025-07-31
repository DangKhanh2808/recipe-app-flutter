import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/recipe.dart';

class VideoPlayerPage extends StatelessWidget {
  final Recipe recipe;

  const VideoPlayerPage({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video Header
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.error,
              ),
              child: Stack(
                children: [
                  // Recipe Image as Video Thumbnail
                  if (recipe.imageUrl != null)
                    Image.network(
                      recipe.imageUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    )
                  else
                    _buildImagePlaceholder(),
                  
                  // Back Button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  
                  // Play Button
                  Center(
                    child: GestureDetector(
                      onTap: () => _openYouTubeVideo(context),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary500,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary500.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Video Info
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        recipe.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Video Stats
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '1.2K lượt xem',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '1 tiếng 20 phút',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Author Section
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.primary500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quách Đăng Khanh',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Chef chuyên nghiệp',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                                                     ElevatedButton(
                             onPressed: () => _openYouTubeVideo(context),
                             style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Xem trên YouTube'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Description
                      Text(
                        'Mô tả',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recipe.instructions ?? 'Không có mô tả chi tiết.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Recipe Info
                      if (recipe.category != null || recipe.area != null) ...[
                        Text(
                          'Thông tin món ăn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (recipe.category != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  recipe.category!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (recipe.area != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  recipe.area!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondary500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.error,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  void _openYouTubeVideo(BuildContext context) {
    if (recipe.youtube != null && recipe.youtube!.isNotEmpty) {
      // Show dialog with YouTube URL
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Xem video trên YouTube'),
          content: Text('Bạn có muốn mở video này trên YouTube?\n\n${recipe.youtube}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copy link YouTube vào clipboard: ${recipe.youtube}'),
                    backgroundColor: AppColors.primary500,
                  ),
                );
              },
              child: Text('Copy Link'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không có video YouTube cho món này'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }
} 