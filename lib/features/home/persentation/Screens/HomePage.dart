import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/recipes_list.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/utiles/assets.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeState.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getdata();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic
            await BlocProvider.of<HomeCubit>(context).getdata();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Custom App Bar with Improved Interaction
                  CustomAppbar(
                    rightPadding: 0,
                    leftPadding: 0,
                    ontapleft: () {
                      // Add profile or menu functionality
                    },
                    ontapright: () {
                      context.pushNamed(AppRoutes.geminiRecipe);
                    },
                    leftImage: Assets.icProfileMenu,
                  ),

                  SizedBox(height: screenSize.height * 0.03),

                  // Welcome Section with Animation Potential
                  const AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    child: Text("Welcome to Your Recipes!"),
                  ),

                  SizedBox(height: screenSize.height * 0.01),

                  // Subtitle with Responsive Text
                  Text(
                    "Discover new recipes or add your ingredients to get started.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),

                  SizedBox(height: screenSize.height * 0.03),

                  // Enhanced Search Bar with Functionality
                  SearchBar(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.focused)) {
                        return Colors.white.withOpacity(0.95);
                      }
                      return Colors.white;
                    }),
                    elevation: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.focused)) {
                        return 3.0;
                      }
                      return 1.0;
                    }),
                    constraints: const BoxConstraints(minHeight: 55, maxHeight: 55),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                    hintText: "Search Recipes",
                    hintStyle: MaterialStateProperty.all(
                      TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onChanged: (value) {
                      // Implement search functionality with optional debounce
                    },
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        Assets.icSearch,
                        color: AppColors.primary,
                        height: 25,
                        width: 25,
                      ),
                    ),
                    trailing: [
                      Tooltip(
                        message: 'Filter Recipes',
                        child: IconButton(
                          icon: Image.asset(
                            Assets.icFilter,
                            color: AppColors.primary,
                            height: 25,
                            width: 25,
                          ),
                          onPressed: () {
                            // Show filter bottom sheet or dialog
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenSize.height * 0.02),

                  // Add Ingredients Button with Haptic Feedback
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact(); // Add subtle vibration
                        Navigator.of(context).pushNamed(AppRoutes.addRecipes);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Your Ingredients",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.03),

                  // Top Recipes Header with Improved Interaction
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Top Recipes",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.pushNamed(AppRoutes.seeAll);
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenSize.height * 0.02),

                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: RecipesList(state: state),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
