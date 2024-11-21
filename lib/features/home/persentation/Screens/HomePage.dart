import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/recipes_list.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/Custome_recipes_card.dart';
import '../../../../core/components/side_bar.dart';
import '../../../../core/utiles/assets.dart';
import '../../../favorites/data/models/favorites.dart';
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
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.focused)) {
                        return Colors.white.withOpacity(0.95);
                      }
                      return Colors.white;
                    }),
                    elevation: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.focused)) {
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

