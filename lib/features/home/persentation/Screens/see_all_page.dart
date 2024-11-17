import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';

import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/routes/app_routes.dart';

import '../../../../core/utiles/assets.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeState.dart';
import '../Widgets/recommended_recipes.dart';
import '../Widgets/trending_recipes.dart';

class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = BlocProvider.of<HomeCubit>(context).dataa;
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context)=>getIt<HomeCubit>()..getdata(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.025),
          child: SafeArea(
            child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
              if (state is IsLoadingHome) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SuccessState) {
                return ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppbar(
                      ontapleft: () {
                        context.pushNamed(AppRoutes.geminiRecipe);
                      },
                      ontapright: () {},
                      leftImage: Assets.icProfileMenu,
                    ),
                    // Trending Recipes Section
                    Text(
                      "Trending Recipes",
                      style:
                          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenSize.height * .02),
                    SizedBox(
                      height: screenSize.height * 0.25,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.data.length, // Adjust the item count as needed
                        separatorBuilder: (context, index) =>
                            SizedBox(width: screenSize.width * .02),
                        itemBuilder: (context, index) {
                          return TrendingRecipeCard(
                            duration: "${state.data[index]["time"]} min",
                            imageUrl: state.data[index]["image"],
                            numberOfIngredients: "${state.data[index]["NOingrediantes"]} ingredients",
                            typeOfMeal: state.data[index]["mealName"],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * .02),

                    // Recommended for you Section
                    Text(
                      "Recommended for you",
                      style:
                          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenSize.height * .017),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.data.length, // Adjust the item count as needed
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.025),
                          child: RecommendedRecipeCard(
                            duration: "${state.data[index]["time"]} min",
                            imageUrl: state.data[index]["image"],
                            numberOfIngredients: "${state.data[index]["NOingrediantes"]} ingredients",
                            typeOfMeal: state.data[index]["mealName"],
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else if (state is FailureState) {
                return Center(child: Text("${state.errorMessage}"));
              } else {
                return Container();
              }
            }),
          ),
        ),
      ),
    );
  }
}
