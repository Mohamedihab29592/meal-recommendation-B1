import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/home/data/data_source/data_source.dart';
import '../../../../core/components/CustomeTextRow.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/Custome_recipes_card.dart';
import '../../../../core/utiles/assets.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeState.dart';
import 'AddRecipes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Assets asset = Assets();
  final AppColors appColors = AppColors();
  final DataSource data = DataSource();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // AppBar
              CustomeAppbar(
                leftImage: "${Assets.icProfileMenu}",
                rightImage: "${Assets.icNotification}",
              ),
              SizedBox(height: 40),

              // Search
              TextFormField(
                autocorrect: true,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Search Recipes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  suffixIcon: Image.asset("${Assets.icFilter}", color: Colors.black, height: 25),
                  prefixIcon: Image.asset("${Assets.icSearch}", color: Colors.black, height: 25),
                ),
              ),

              // Add Ingredients Button
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddRecipes()));
                },
                child: Text(
                  "Add Your Ingredients",
                  style: TextStyle(color: Colors.white, fontSize: screenSize.width < 600 ? 12 : 16),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              ),

              // Top Recipes & View All
              CustomeTextRow(leftText: "Top Recipes", rightText: "See All"),

              // Card ==> Description Meal
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is IsLoadingHome) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SuccessState) {
                    return Container(
                      height: screenSize.height * 0.4, // Responsive height
                      child: ListView.builder(
                        itemCount: BlocProvider.of<HomeCubit>(context).dataa.length,
                        itemBuilder: (context, index) => CustomeRecipesCard(
                          ontap: () {},
                          firsttext: "${BlocProvider.of<HomeCubit>(context).dataa[index]["typeofmeal"]}",
                          ingrediantes: "${BlocProvider.of<HomeCubit>(context).dataa[index]["NOingrediantes"]} ingredients",
                          time: "${BlocProvider.of<HomeCubit>(context).dataa[index]["time"]} min",
                          middleText: "${BlocProvider.of<HomeCubit>(context).dataa[index]["mealName"]}",
                          image: "${BlocProvider.of<HomeCubit>(context).dataa[index]["image"]}",
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
