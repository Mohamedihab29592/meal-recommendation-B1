import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_buttons.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_list_view.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/di.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../../../core/utiles/assets.dart';
import '../../../../core/utiles/helper.dart';
import '../../../home/persentation/Cubits/AddRecipesCubit/add_ingredient_cubit.dart';
import '../bloc/RecipeBloc.dart';
import '../bloc/RecipeEvent.dart';
import '../bloc/RecipeState.dart';
import 'CustomSearchBar.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  RecipeSearchScreenState createState() => RecipeSearchScreenState();
}

class RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showSavedRecipes = false;

  @override
  void initState() {
    super.initState();
    try {
      context.read<RecipeBloc>().add(CombineRecipesEvent());
    } catch (e) {
      debugPrint('Error in initState: $e');
      // Optionally show an error dialog or snackbar
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipesSaved) {
              showNotification(
                  context, 'Recipes saved successfully!', ContentType.success);
            } else if (state is RecipeError) {
              showNotification(context, state.message, ContentType.failure);
            }
          },
          builder: (context, state) {
            int newRecipesCount = _getNewRecipesCount(context.read<RecipeBloc>());


            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomAppbar(
                    ontapleft: () => showCleanupOptions(context),
                    ontapright: () {
                      context.pushNamed(AppRoutes.geminiRecipe);
                    },
                    leftChild: IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.cleaning_services,
                          color: AppColors.primary),
                      onPressed: () => showCleanupOptions(context),
                    ),
                    rightChild: RecipeButtons(
                      recipesCount: newRecipesCount,
                      showSavedRecipes: _showSavedRecipes,
                      onSave: () => showSaveConfirmationDialog(context),
                      onToggleSavedRecipes: () {
                        setState(() {
                          _showSavedRecipes = !_showSavedRecipes;
                        });
                        if (_showSavedRecipes) {
                          context.read<RecipeBloc>().add(LoadSavedRecipesEvent());
                        } else {
                          context.read<RecipeBloc>().add(CombineRecipesEvent());
                        }
                      },
                    ),
                    leftImage: Assets.icProfileMenu,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocProvider.value(
                      value: getIt<AddIngredientCubit>(),
                      child: RecipeListView(
                        state: state,
                        showSavedRecipes: _showSavedRecipes,
                      ),
                    ),
                  ),
                  CustomSearchBar(
                    controller: _controller,
                    onSearch: (query) {
                      if (query.isNotEmpty) {
                        context.read<RecipeBloc>().add(FetchRecipesEvent(query));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  int _getNewRecipesCount(RecipeBloc recipeBloc) {
    return recipeBloc.fetchedRecipes
        .where((fetchedRecipe) => !recipeBloc.savedRecipes
        .any((savedRecipe) => savedRecipe.id == fetchedRecipe.id))
        .length;
  }

}




