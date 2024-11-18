import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/components/my_loading_dialog.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import '../../../../core/components/custom_recipes_card.dart';
import '../data/models/favorites.dart';
import 'bloc/favorites_bloc.dart';
import 'bloc/favorites_event.dart';
import 'bloc/favorites_state.dart';
class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  List<Favorites> favorites = [];
  String selectedId = "";

  void removeFromFavorite(String id) {
    favorites.removeWhere((element) {
      return element.id == selectedId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FavoritesBloc>()..add(GetAllFavoritesEvent()),
      child: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesLoading) {
            MyLoadingDialog.show(context);
          } else if (state is DeleteFavoriteDone) {
            MyLoadingDialog.hide(context);
            removeFromFavorite(selectedId);
          } else if (state is DeleteFavoriteError) {
            MyLoadingDialog.hide(context);
          } else if (state is GetAllFavoritesDone) {
            MyLoadingDialog.hide(context);
            favorites = state.favorites;
          } else if (state is GetAllFavoritesError) {
            MyLoadingDialog.hide(context);
          }
        },
        builder: (context, state) {
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
                          selectedId = favorites[index].id;
                          BlocProvider.of<FavoritesBloc>(context).add(
                              DeleteFavoriteEvent(selectedId));
                        },
                        time: favorites[index].timing,
                        middleText: favorites[index].subTitle,
                        firstText: favorites[index].title,
                        ingredients: favorites[index].ingredients,
                        image: favorites[index].image,
                        onTapDelete: () {}, mealId: '',
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10.h,
                      );
                    },
                    itemCount: favorites.length),
              ),
            ),
          );
        },
      ),
    );
  }
}
