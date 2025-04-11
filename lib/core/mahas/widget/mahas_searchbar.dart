import 'package:flutter/material.dart';
import '../../theme/app_color.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typografi.dart';

class MahasSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final bool elevated;

  const MahasSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final searchField = TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyText2,
        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.grey),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          borderSide: const BorderSide(color: AppColors.black, width: 2),
        ),
      ),
      onChanged: onChanged,
    );

    if (!elevated) {
      return Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: searchField,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        elevation: 2,
        child: searchField,
      ),
    );
  }
}
