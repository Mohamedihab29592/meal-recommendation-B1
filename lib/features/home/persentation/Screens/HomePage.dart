import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/data/data_source/data_source.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/DetailsPage.dart';
import '../../../../core/components/CustomeTextRow.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/Custome_recipes_card.dart';
import '../../../../core/components/side_bar.dart';
import '../../../../core/utiles/assets.dart';
import '../../../favorites/data/models/favorites.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeState.dart';

class HomePage extends StatelessWidget {
  final Assets asset = Assets();
  final AppColors appColors = AppColors();
  final DataSource data = DataSource();
  String? name, idDoc;

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
                // Custom AppBar with profile menu and navigation
                CustomAppbar(
                  ontapleft: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context) => SideBar(oldIndex: 0, returnedIndex: (){},),));
                  },
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
                    if (state is IsLoadingHome) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SuccessState) {
                      return Column(
                        children: [
                          ListView(
                            shrinkWrap: true, // Makes the ListView adapt to its content
                            physics: const NeverScrollableScrollPhysics(), // Disables scrolling
                            children: BlocProvider.of<HomeCubit>(context)
                                .dataa
                                .asMap()
                                .entries
                                .map((entry) {
                              var index = entry.key;
                              var meal = entry.value;

                              return InkWell(
                                onTap: () async {
                                  final detailsCubit = BlocProvider.of<DetailsCubit>(context);
                                  detailsCubit.getDetailsData(context);
                                  detailsCubit.reff =
                                  BlocProvider.of<HomeCubit>(context).dataa[index]['typeofmeal'];

                                  context.pushNamed(AppRoutes.detailsPage);
                                },
                                child: CustomeRecipesCard(
                                  key: ValueKey(meal["id"]), // Add a unique key
                                  ontapDelete: () {
                                    String mealId = meal["id"];
                                    showDeleteDialog(
                                      context: context,
                                      mealId: mealId,
                                      onSuccess: () {
                                        BlocProvider.of<HomeCubit>(context).deleteRecipe(mealId);
                                      },
                                    );
                                  },
                                  ontapFav: () {
                                    // Add to favorite functionality
                                  },
                                  firsttext: meal["typeofmeal"] ?? "",
                                  ingrediantes: "${meal["NOingrediantes"] ?? 0} ingredients",
                                  time: "${meal["time"] ?? 0} min",
                                  middleText: meal["mealName"] ?? "",
                                  image: meal["image"] ?? "",
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    } else if (state is FailureState) {
                      return Center(
                          child: Text(state.errorMessage ?? "Error!"));
                    } else {
                      return const SizedBox.shrink();
                    }
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

        // Query the Firestore collection for the document matching the given ID
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection("Recipes")
            .where("id", isEqualTo: mealId) // Match the field 'id'
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Delete all matching documents
          for (var doc in snapshot.docs) {
            await doc.reference.delete();
            print("Successfully deleted document ID: ${doc.id}");
          }
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meal deleted successfully!')),
          );
          // Trigger success callback to refresh UI or perform navigation
          onSuccess();
        } else {
          print("No document found with ID: $mealId");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No meal found to delete!')),
          );
        }
      } catch (e) {
        print("Error deleting document: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete meal: $e')),
        );
      }
    },
  ).show();
}