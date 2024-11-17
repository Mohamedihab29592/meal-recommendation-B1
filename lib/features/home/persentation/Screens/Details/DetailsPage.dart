import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/Custome_Appbar.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsState.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/IngrediantScreen.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/Details/SummaryScreen.dart';

import '../../../../../core/utiles/assets.dart';
import 'DirectionScreen.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => DetailsCubit()..getDetailsData(context),
      child: Scaffold(
        body: BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) {
            if (state is IsLoadingDetailsState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SucessState) {
              final recipe = BlocProvider.of<DetailsCubit>(context).dataref.first; // Access recipe data here
              return SafeArea(
                child: Column(
                  children: [
                    // AppBar
                    CustomAppbar(
                      ontapleft: () => Navigator.pop(context),
                      ontapright: () {
                        String docId=BlocProvider.of<HomeCubit>(context).idDoc.toString();
                        print(docId);
                      },
                      leftImage: Assets.icBack,

                    ),

                    // Image
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      height: screenSize.height * 0.25, // Responsive height
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(recipe['image']),
                          fit: BoxFit.cover, // Use cover for better aspect ratio management
                        ),
                      ),
                    ),

                    // Details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for the text
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            recipe['mealName'],
                            style: TextStyle(
                              fontSize: screenSize.width * 0.07, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${recipe['typeofmeal']}.",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04, // Responsive font size
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black26,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${recipe['time']} min.",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04, // Responsive font size
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black26,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "1 Serving",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04, // Responsive font size
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black26,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // TabBar
                    Container(
                      width: double.infinity,
                      height: screenSize.height * 0.06, // Responsive height
                      child: TabBar(
                        dividerColor: AppColors.white,
                        unselectedLabelColor: Colors.black26,
                        labelColor: AppColors.black,
                        controller: _tabController,
                        tabs: [
                          Tab(child: Text("Summary")),
                          Tab(child: Text("Ingrediants")),
                          Tab(child: Text("Direction")),
                        ],
                      ),
                    ),
                    // TabBarView
                    Container(
                      width: double.infinity,
                      height: screenSize.height * 0.42, // Responsive height
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SummaryScreen(),
                          IngrediantsScreen(),
                          DirectionPage(), // Example content for the third tab
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is FailureState) {
              return Center(child: Text("${state.errorMessage}"));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}