import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/components/loading_dialog.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeState.dart';
import '../Widgets/recommended_recipes.dart';
import '../Widgets/trending_recipes.dart';

class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..getdata(),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<HomeCubit>().getdata();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.primary,
                  floating: true,
                  snap: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    'Discover Recipes',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color:  Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon:  const Icon(Icons.search,color: Colors.white),
                      onPressed: () {
                        // Implement search functionality
                      },
                    ),
                  ],
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is IsLoadingHome) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const LoadingDialog(message: 'Loading Recipes...'),
                              SizedBox(height: screenSize.height * 0.02),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is FailureState) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 80.sp,
                                color: Colors.red,
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              Text(
                                'Oops! Something went wrong',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.errorMessage ?? 'Unknown error',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<HomeCubit>().getdata();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is SuccessState) {
                      // Check if data is empty
                      if (state.data.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.no_food_outlined,
                                  size: 80.sp,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: screenSize.height * 0.02),
                                Text(
                                  'No Recipes Found',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Try refreshing or check your connection',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Trending Recipes Section
                          _buildSectionHeader('Trending Recipes'),
                          SizedBox(
                            height: screenSize.height * 0.3,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.025,
                              ),
                              itemCount: state.data.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: screenSize.width * 0.02),
                              itemBuilder: (context, index) {
                                final recipe = state.data[index];
                                return TrendingRecipeCard(
                                  duration: "${recipe["time"]} min",
                                  imageUrl: recipe["imageUrl"],
                                  numberOfIngredients: "${(recipe["ingredients"] as List).length} ingredients", // Count ingredients
                                  typeOfMeal: recipe["name"],
                                );
                              },
                            ),
                          ),

                          // Recommended for you Section
                          _buildSectionHeader('Recommended for You'),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              final recipe = state.data[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.025,
                                  vertical: screenSize.height * 0.01,
                                ),
                                child: RecommendedRecipeCard(
                                  duration: "${recipe["time"]} min",
                                  imageUrl: recipe["imageUrl"],
                                  numberOfIngredients: "${(recipe["ingredients"] as List).length} ingredients", // Count ingredients
                                  typeOfMeal: recipe["name"],
                                ),
                              );
                            },
                          ),
                        ]),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
