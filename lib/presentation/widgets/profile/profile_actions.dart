import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileActions extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMessageTap;

  const ProfileActions({
    Key? key,
    this.isFollowing = false,
    this.onFollowTap,
    this.onMessageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onFollowTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowing ? AppColors.neutral200 : AppColors.primary500,
                foregroundColor: isFollowing ? AppColors.textPrimary : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                isFollowing ? 'Đã theo dõi' : 'Follow',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: onMessageTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary500,
                side: const BorderSide(color: AppColors.primary500),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Message',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 