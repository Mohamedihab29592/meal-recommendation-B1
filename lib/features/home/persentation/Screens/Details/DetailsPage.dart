import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsState.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/IngrediantScreen.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/SummaryScreen.dart';
import '../../../../../core/components/loading_dialog.dart';
import '../../../../../core/utiles/app_colors.dart';
import '../../../../gemini_integrate/data/Recipe.dart';
import 'DirectionScreen.dart';

class DetailsPage extends StatefulWidget {
  final String recipeId;

  const DetailsPage({super.key, required this.recipeId});

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    BlocProvider.of<DetailsCubit>(context).fetchRecipeDetails(widget.recipeId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper method to build recipe info chip
  Widget _buildRecipeInfoChip({
    required IconData icon,
    required String label,
    Color? iconColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: iconColor ?? Colors.black54,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style:  const TextStyle(
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          // Loading State
          if (state is LoadingState) {
            return const LoadingDialog(message: 'Loading Recipes...');
          }

          // Success State
          else if (state is LoadedState) {
            final Recipe recipe = state.recipe;

            return DefaultTabController(
              length: 3,
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                expandedHeight: screenSize.height * 0.35,
                pinned: true,
                floating: false,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      // Add to favorites logic
                    },
                  ),
                ],
                title: _buildScrolledTitleWidget(recipe, screenSize),
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: _buildFlexibleTitle(recipe, screenSize),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [

                      _buildRecipeImage(recipe.imageUrl),

                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

                  // Recipe Info Sliver
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildRecipeInfoChip(
                            icon: Icons.timer,
                            label: "${recipe.time} min",
                            iconColor: Colors.orange,
                          ),
                          _buildRecipeInfoChip(
                            icon: Icons.restaurant,
                            label: recipe.typeOfMeal,
                            iconColor: Colors.green,
                          ),
                          _buildRecipeInfoChip(
                            icon: Icons.person,
                            label: "1 Serving",
                            iconColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tab Bar Sliver
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        tabs: const [
                          Tab(text: "Summary",),
                          Tab(text: "Ingredients"),
                          Tab(text: "Directions"),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    SummaryScreen(recipe: recipe),
                    IngredientsScreen(recipe: recipe),
                    DirectionPage(recipe: recipe),
                  ],
                ),
              ),
            );
          }

          // Failure State
          else if (state is ErrorState) {
            return _buildErrorWidget(context, state.message);
          }

          // Default state
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFlexibleTitle(Recipe recipe, Size screenSize) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {
        final scrollOffset = _scrollController.hasClients
            ? _scrollController.offset
            : 0.0;
        final maxScrollExtent = screenSize.height * 0.35 - kToolbarHeight;

        // Calculate opacity based on scroll position
        final opacity = max(0.0, min(1.0, 1.0 - (scrollOffset / maxScrollExtent)));

        return Opacity(
          opacity: opacity,
          child: Text(
            recipe.name[0].toUpperCase() + recipe.name.substring(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeImage(String imageUrl) {
    return imageUrl.isNotEmpty
        ? Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.white,
            ),
          ),
        );
      },
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
    )
        : Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<DetailsCubit>(context)
                  .fetchRecipeDetails(widget.recipeId);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildScrolledTitleWidget(Recipe recipe, Size screenSize) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {

        bool showCircularImage = _scrollController.hasClients &&
            _scrollController.offset > (screenSize.height * 0.35 - kToolbarHeight);

        return showCircularImage
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: recipe.imageUrl.isNotEmpty
                  ? NetworkImage(recipe.imageUrl)
                  : null,
              child: recipe.imageUrl.isEmpty
                  ? const Icon(Icons.restaurant, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                recipe.name[0].toUpperCase() + recipe.name.substring(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
            : const SizedBox.shrink();
      },
    );
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent
      ) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}