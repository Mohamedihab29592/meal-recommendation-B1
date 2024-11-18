import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/recipe_card_widget.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utiles/assets.dart';
import '../Cubits/DetailsCubit/DetailsCubit.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import '../Cubits/HomeCubit/HomeState.dart';
import 'custom_recipes_card_shimmer.dart';
import 'empty_state_widget.dart';
import 'error_state_widget.dart';

class RecipesList extends StatelessWidget {
  final HomeState state;

  const RecipesList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is IsLoadingHome) {
      return Column(
        children: List.generate(
          5,
          (_) => const CustomRecipesCardShimmer(),
        ),
      );
    }

    if (state is SuccessState) {
      final successState = state as SuccessState;

      if (successState.data.isEmpty) {
        return EmptyStateWidget(
          image: Assets.noFoodFound,
          title: "No Recipes Found",
          subtitle: "Add your first recipe and start cooking!",
          onActionPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.addRecipes);
          },
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: successState.data.length,
        itemBuilder: (context, index) {
          var meal = successState.data[index];

          return RecipeCardWidget(
            meal: meal,
            onTap: () =>  context.pushNamed(AppRoutes.detailsPage,arguments: meal["id"]),
          );
        },
      );
    }

    if (state is FailureState) {
      final failureState = state as FailureState;

      return ErrorStateWidget(
        errorMessage:
            failureState.errorMessage ?? "An unexpected error occurred",
        onRetry: () {
          BlocProvider.of<HomeCubit>(context).getdata();
        },
      );
    }

    return const SizedBox.shrink();
  }


}
