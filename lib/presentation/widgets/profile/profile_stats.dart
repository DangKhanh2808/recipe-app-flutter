import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileStats extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;

  const ProfileStats({
    Key? key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Bài viết', postsCount.toString()),
        _buildDivider(),
        _buildStatItem('Người theo dõi', followersCount.toString()),
        _buildDivider(),
        _buildStatItem('Theo dõi', followingCount.toString()),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: AppColors.neutral300,
    );
  }
} 