import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrendingRecipeCard extends StatefulWidget {
  final String imageUrl;
  final String duration;
  final String numberOfIngredients;
  final String typeOfMeal;

  const TrendingRecipeCard({
    super.key,
    required this.duration,
    required this.typeOfMeal,
    required this.imageUrl,
    required this.numberOfIngredients,
  });

  @override
  TrendingRecipeCardState createState() => TrendingRecipeCardState();
}

class TrendingRecipeCardState extends State<TrendingRecipeCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Navigate to recipe details
        // context.pushNamed(AppRoutes.recipeDetails, extra: widget);
      },
      child: Container(
        width: screenSize.width * 0.7,
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image with Loading and Error Handling
              _buildImageBackground(screenSize),

              // Gradient Overlay
              _buildGradientOverlay(),

              // Favorite Button
              _buildFavoriteButton(),

              // Recipe Details
              _buildRecipeDetails(),

              // Difficulty and Rating Chip
              _buildDifficultyRatingChip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageBackground(Size screenSize) {
    return Positioned.fill(
      child: Builder(
        builder: (context) {
          try {
            return Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Fallback to CachedNetworkImage
                return CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey[600],
                        size: 50,
                      ),
                    ),
                  ),
                );
              },
            );
          } catch (e) {
            print('Image loading error: $e');
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey[600],
                  size: 50,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.1, 0.8],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFavorite = !_isFavorite;
          });
          // Implement favorite logic
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
          ),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeDetails() {
    return Positioned(
      bottom: 15,
      left: 15,
      right: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Name with Shadow and Responsive Text
          LayoutBuilder(
            builder: (context, constraints) {
              return Text(
                widget.typeOfMeal[0].toUpperCase() + widget.typeOfMeal.substring(1),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: _calculateFontSize(constraints.maxWidth),
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          SizedBox(height: 10.h),

          // Responsive Recipe Info Row
          _buildRecipeInfoRow(),
        ],
      ),
    );
  }

// Dynamic font size calculation
  double _calculateFontSize(double width) {
    if (width > 400) return 22.sp;
    if (width > 300) return 20.sp;
    return 18.sp;
  }

  Widget _buildRecipeInfoRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildIconText(
            icon: Icons.restaurant_menu,
            text: widget.numberOfIngredients,
            color: Colors.white70,
          ),
          SizedBox(width: 15.w),
          _buildIconText(
            icon: Icons.timer_outlined,
            text: widget.duration,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _buildIconText({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDifficultyRatingChip() {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              '4.5',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}