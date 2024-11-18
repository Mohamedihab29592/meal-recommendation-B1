import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsState.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/IngrediantScreen.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/SummaryScreen.dart';
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

    // Use BlocProvider.of instead of context.read
    BlocProvider.of<DetailsCubit>(context).fetchRecipeDetails(widget.recipeId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper method to build recipe info chip
  Widget _buildRecipeInfoChip({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
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
            return const Center(child: CircularProgressIndicator());
          }

          // Success State
          else if (state is LoadedState) {
            final recipe = state.recipe;

            return DefaultTabController(
              length: 3,
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  // Sliver App Bar
                  SliverAppBar(
                    expandedHeight: screenSize.height * 0.35,
                    pinned: true,
                    floating: false,
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
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        recipe['name'] ?? 'Recipe',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Check if image exists before loading
                          recipe['imageUrl'] != null
                              ? Image.network(
                            recipe['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          )
                              : Container(color: Colors.grey[300]),

                          // Gradient overlay
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
                            label: "${recipe['time'] ?? 'N/A'} min",
                          ),
                          _buildRecipeInfoChip(
                            icon: Icons.restaurant,
                            label: recipe['typeOfMeal'] ?? 'Unknown',
                          ),
                          _buildRecipeInfoChip(
                            icon: Icons.person,
                            label: "1 Serving",
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
                          Tab(text: "Summary"),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
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

          // Default state
          return Container();
        },
      ),
    );
  }
}

// Custom Sliver Delegate
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