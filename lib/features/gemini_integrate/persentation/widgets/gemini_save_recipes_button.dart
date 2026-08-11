import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utiles/app_colors.dart';

class GeminiSaveRecipesButton extends StatefulWidget {
  final VoidCallback onSave;
  final int recipesCount;

  const GeminiSaveRecipesButton({
    super.key,
    required this.onSave,
    required this.recipesCount,
  });

  @override
  GeminiSaveRecipesButtonState createState() => GeminiSaveRecipesButtonState();
}

class GeminiSaveRecipesButtonState extends State<GeminiSaveRecipesButton> {
  bool _isHovered = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _isSaving ? null : _handleSave,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isSaving
                  ? [Colors.grey.shade300, Colors.grey.shade200]
                  : _isHovered
                      ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
                      : [AppColors.primary, AppColors.primary.withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered && !_isSaving
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  void _handleSave() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      widget.onSave();
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildButtonContent() {
    if (_isSaving) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.save_rounded,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Save Recipes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                  )
                ],
              ),
            ),
            if (widget.recipesCount > 0)
              Text(
                '${widget.recipesCount} New Recipes',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
