import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/custom_recipes_card.dart';
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CustomAppbar(
                  rightPadding: 0,
                  leftPadding: 0,
                  ontapleft: () {},
                  ontapright: () {
                    context.pushNamed(AppRoutes.geminiRecipe);
                  },
                  leftImage: Assets.icProfileMenu,
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Welcome Text
                const Text(
                  "Welcome to Your Recipes!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),

                // Subtitle
                Text(
                  "Discover new recipes or add your ingredients to get started.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Search Bar with Filter Icon
                TextFormField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Search Recipes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.grey[400]!, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                    suffixIcon: Image.asset(Assets.icFilter,
                        color: Colors.black, height: 25),
                    prefixIcon: Image.asset(Assets.icSearch,
                        color: Colors.black, height: 25),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Add Ingredients Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
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
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Top Recipes Header with "See All"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Top Recipes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRoutes.seeAll);
                      },
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Recipes List
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    print('Current state: $state'); // Debug print to track state changes

                    if (state is IsLoadingHome) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SuccessState) {
                      print('Recipes in state: ${state.data}'); // Check the contents of the recipes

                      if (state.data.isEmpty) {
                        return Center(
                          child: Image.asset(Assets.noFoodFound)
                        );
                      }

                      // Check if the first recipe has valid fields
                      var firstRecipe = state.data.first;
                      print('First recipe: $firstRecipe'); // Log the first recipe

                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            var meal = state.data[index];

                            String mealId = meal["id"] ?? "Unknown ID";
                            String mealName = meal["name"]?.isNotEmpty == true
                                ? meal["name"]
                                : "Unnamed Meal";
                            String mealType = meal["typeOfMeal"]?.isNotEmpty ==
                                true ? meal["typeOfMeal"] : "Unknown Type";
                            String mealImage = meal["imageUrl"] ??
                                "";

                            return InkWell(
                              onTap: () async {
                                final detailsCubit = BlocProvider.of<
                                    DetailsCubit>(context);
                                detailsCubit.getDetailsData(context);
                                detailsCubit.reff = mealType;

                                context.pushNamed(AppRoutes.detailsPage);
                              },
                              child: CustomRecipesCard(
                                key: ValueKey(mealId),
                                onTapDelete: () {
                                  showDeleteDialog(
                                    context: context,
                                    mealId: mealId,
                                    onSuccess: () {
                                      BlocProvider.of<HomeCubit>(context)
                                          .getdata();
                                    },
                                  );
                                },
                                onTapFav: () {
                                  // Add to favorite functionality
                                },
                                firstText: mealType,
                                ingredients: meal["ingredients"] != null &&
                                    meal["ingredients"].isNotEmpty
                                    ? "${meal["ingredients"]
                                    .length} ingredients"
                                    : "No ingredients available",
                                time: meal["time"]?.isNotEmpty == true
                                    ? "${meal["time"]} min"
                                    : "N/A",
                                middleText: mealName,
                                image: mealImage,
                              ),
                            );
                          }
                          ),
                        ],
                      );
                    }

                    if (state is FailureState) {
                      return Center(
                          child: Text(
                            state.errorMessage ?? "An error occurred",
                            style: const TextStyle(color: Colors.red),
                          )
                      );
                    }

                    return const SizedBox.shrink();
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showDeleteDialog({
  required BuildContext context,
  required String mealId,
  required VoidCallback onSuccess,
}) async {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.rightSlide,
    title: 'Delete Meal',
    desc: 'Are you sure you want to delete this meal?',
    btnCancelOnPress: () {
      // Optional: Perform actions on cancel
    },
    btnOkOnPress: () async {
      try {
        print("Attempting to delete document with ID: $mealId");

        final homeCubit = BlocProvider.of<HomeCubit>(context);


        await homeCubit.deleteRecipe(mealId);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal deleted successfully!')),
        );

        // Trigger success callback to refresh UI or perform navigation
        onSuccess();
      } catch (e) {
        print("Error deleting document: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete meal: $e')),
        );
      }
    },
  ).show();
}
