import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/components/my_loading_dialog.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeState.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/NavBarCubits/NavBarCubit.dart';
import '../../../../core/components/custom_recipes_card.dart';
import '../data/models/favorites.dart';
import 'bloc/favorites_bloc.dart';
import 'bloc/favorites_state.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  String selectedId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyContent(context),
    );
  }
@override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getFavoriteRecipes();
    super.initState();
  }
  Widget bodyContent(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FavoriteRecipesState) {
            var favoriteList = state.favoriteRecipes;
            return Padding(
              padding: EdgeInsets.only(top: 75.h),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height - 230.h,
                  width: MediaQuery.sizeOf(context).width,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CustomRecipesCard(
                          onTapFav: () {
                            BlocProvider.of<HomeCubit>(context)
                                .toggleFavoriteLocal(
                                    favoriteList[index].id ?? "");
                          },
                          time: favoriteList[index].time,
                          middleText: favoriteList[index].summary,
                          firstText: favoriteList[index].name,
                          ingredients:
                              favoriteList[index].ingredients[index].quantity,
                          image: favoriteList[index].imageUrl,
                          onTapDelete: () {},
                          mealId: '',
                          isFavorite: false,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10.h,
                        );
                      },
                      itemCount: favoriteList.length),
                ),
              ),
            );
          }else if (state is IsLoadingFavorites){
            return const Text("LOADING");
          } else {
            return const Text("done");
          }
        },
      ),
    );
  }
}
