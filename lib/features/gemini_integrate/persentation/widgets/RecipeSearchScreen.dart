import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/loading_chat_widget.dart';

import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/dynamic_notification_widget.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../../../core/utiles/assets.dart';
import '../bloc/RecipeBloc.dart';
import '../bloc/RecipeEvent.dart';
import '../bloc/RecipeState.dart';
import 'CustomSearchBar.dart';
import 'RecipeCard.dart';

class RecipeSearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  RecipeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipesSaved) {
              DynamicNotificationWidget.showNotification(
                context: context,
                title: 'Oh Hey!!',
                message: 'Recipes saved successfully!',
                color: Colors.green, // You can use this color if needed
                contentType: ContentType.success,
                inMaterialBanner: false,
              );
            } else if (state is RecipeError) {
              DynamicNotificationWidget.showNotification(
                context: context,
                title: 'Oh Hey!!',
                message: state.message,
                color: Colors.green, // You can use this color if needed
                contentType: ContentType.failure,
                inMaterialBanner: false,
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomAppbar(
                    ontapleft: () {},
                    ontapright: () {
                      context.pushNamed(AppRoutes.geminiRecipe);
                    },
                    rightChild: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        _showSaveConfirmationDialog(context);
                      },
                      child: const Text('Save Recipes'),
                    ),
                    leftImage: Assets.icProfileMenu,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildRecipeList(state),
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

  Widget _buildRecipeList(RecipeState state) {
    if (state is RecipeLoading) {
      return const LoadingChatWidget();
    } else if (state is RecipeLoaded) {
      return ListView.builder(
        itemCount: state.recipes.length,
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          final recipe = state.recipes[index];
          return RecipeCard(recipe: recipe);
        },
      );
    } else if (state is RecipeError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return Image.asset(Assets.noFoodFound);
  }

  void _showSaveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Recipes'),
        content: const Text('Do you want to save these recipes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white
            ),
            onPressed: () {
              context.read<RecipeBloc>().add(SaveRecipesEvent());
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}