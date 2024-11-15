import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/data/data_source/data_source.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/DetailsPage.dart';
import '../../../../core/components/CustomeTextRow.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/Custome_recipes_card.dart';
import '../../../../core/utiles/assets.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeState.dart';

class HomePage extends StatelessWidget {
  final Assets asset = Assets();
  final AppColors appColors = AppColors();
  final DataSource data = DataSource();
  String? name,idDoc;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return
      Scaffold(
        body: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.025),
          // Responsive padding
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // AppBar
                CustomAppbar(
                  ontapleft: () {

                  },
                  ontapright: () {
                    context.pushNamed(AppRoutes.geminiRecipe);
                  },
                  leftImage: Assets.icProfileMenu,
                ),
                SizedBox(height: screenSize.height * 0.05),
                // Responsive spacing

                // Search
                TextFormField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Search Recipes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
                    suffixIcon: Image.asset(Assets.icFilter,
                        color: Colors.black, height: 25),
                    prefixIcon: Image.asset(Assets.icSearch,
                        color: Colors.black, height: 25),
                  ),
                ),

                // Add Ingredients Button
                SizedBox(height: screenSize.height * 0.02),
                // Responsive spacing
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.addRecipes);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  child: Text(
                    "Add Your Ingredients",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width < 600
                            ? 12
                            : 16), // Responsive font size
                  ),
                ),

                // Top Recipes & View All
                CustomeTextRow(leftText: "Top Recipes", rightText: "See All"),

                // Card ==> Description Meal
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is IsLoadingHome) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SuccessState) {
                      return SizedBox(
                        height: screenSize.height * 0.46, // Responsive height
                        child: ListView.builder(
                          itemCount:
                              BlocProvider.of<HomeCubit>(context).dataa.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async {
                              final detailsCubit = BlocProvider.of<DetailsCubit>(context); // Ensure it's available
                              detailsCubit.getDetailsData(context);
                              detailsCubit.reff = BlocProvider.of<HomeCubit>(context).dataa[index]['typeofmeal'];

                              context.pushNamed(AppRoutes.detailsPage);
                            },
                            child: CustomeRecipesCard(
                              //delete meal
                              ontapDelete: () {
                                // Get the idDoc from the HomeCubit
                                String idDoc = BlocProvider.of<HomeCubit>(context).dataa[index]["id"];

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'Delete Meal',
                                  desc: 'Are you sure you want to delete this meal?',
                                  btnCancelOnPress: () {
                                    Navigator.of(context).pop(); // Close the dialog without action
                                  },
                                  btnOkOnPress: () async {
                                    try {
                                      print("Attempting to delete document with ID: $idDoc");

                                      QuerySnapshot snapshot = await FirebaseFirestore.instance
                                          .collection("Recipes")
                                          .where("id", isEqualTo: idDoc) // Match the field 'id'
                                          .get();
                                      // Check if any documents were found
                                      if (snapshot.docs.isNotEmpty) {
                                        for (var doc in snapshot.docs) {
                                          await doc.reference.delete();
                                          print("Successfully deleted document ID: ${doc.id}");
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Meal deleted successfully!'))
                                        );
                                      } else {
                                        print("No document found with ID: $idDoc");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('No meal found to delete!'))
                                        );
                                      }
                                      Navigator.of(context).pushReplacementNamed(AppRoutes.navBar);
                                    } catch (e) {
                                      print("Error deleting document: $e");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to delete meal: $e'))
                                      );
                                    }
                                  },
                                ).show();
                              },

                              //fav button
                              ontapFav: () {},
                              firsttext:
                                  "${BlocProvider.of<HomeCubit>(context).dataa[index]["typeofmeal"]}",
                              ingrediantes:
                                  "${BlocProvider.of<HomeCubit>(context).dataa[index]["NOingrediantes"]} ingredients",
                              time:
                                  "${BlocProvider.of<HomeCubit>(context).dataa[index]["time"]} min",
                              middleText:
                                  "${BlocProvider.of<HomeCubit>(context).dataa[index]["mealName"]}",
                              image:
                                  "${BlocProvider.of<HomeCubit>(context).dataa[index]["image"]}",
                            ),
                          ),
                        ),
                      );
                    } else if (state is FailureState) {
                      return Center(child: Text("${state.errorMessage}"));
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }
}
