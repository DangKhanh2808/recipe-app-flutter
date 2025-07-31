import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

    @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Bottom Navigation Items with FAB
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home
                _buildNavItem(
                  icon: Icons.home,
                  index: 0,
                  isSelected: currentIndex == 0,
                ),
                // Search
                _buildNavItem(
                  icon: Icons.search,
                  index: 1,
                  isSelected: currentIndex == 1,
                ),
                // Floating Action Button
                GestureDetector(
                  onTap: () {
                    // TODO: Handle FAB tap
                  },
                  child: Container(
                    width: 50,
                    height: 50,
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
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                // Bookmarks
                _buildNavItem(
                  icon: Icons.bookmark_border,
                  index: 2,
                  isSelected: currentIndex == 2,
                ),
                // Profile
                _buildNavItem(
                  icon: Icons.person_outline,
                  index: 3,
                  isSelected: currentIndex == 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary500 : AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
} 