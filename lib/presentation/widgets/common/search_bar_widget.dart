import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Tìm kiếm công thức...',
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        controller: controller ?? (initialValue != null 
            ? TextEditingController(text: initialValue)
            : null),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              Icons.tune,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
    );
  }
} 