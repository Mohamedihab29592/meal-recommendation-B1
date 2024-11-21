import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/add_ingredient_cubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/add_ingredient_state.dart';
import '../../../../core/components/dynamic_notification_widget.dart';
import '../../../../core/services/di.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../data/Recipe.dart';

class AddIngredientsButton extends StatefulWidget {
  final Recipe recipe;


  const AddIngredientsButton({
    super.key,
    required this.recipe,
  });

  @override
  AddIngredientsButtonState createState() => AddIngredientsButtonState();
}

class AddIngredientsButtonState extends State<AddIngredientsButton> {
  bool _isAlreadyAdded = false;

  @override
  void initState() {
    super.initState();
    _checkIngredientsAdded();
  }

  Future<void> _checkIngredientsAdded() async {
    try {
      final isAdded = await context.read<AddIngredientCubit>().checkIngredientsAdded(widget.recipe);
      if (mounted) {
        setState(() {
          _isAlreadyAdded = isAdded;
        });
      }
    } catch (e) {
      print('Error checking ingredients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddIngredientCubit, AddIngredientState>(
      listener: (context, state) {
        if (state is AddIngredientSuccess) {
          _showNotification(
              context,
              'Ingredients added successfully',
              ContentType.success
          );
          setState(() {
            _isAlreadyAdded = true;
          });
        } else if (state is AddIngredientAlreadyAdded) {
          _showNotification(
              context,
              'These ingredients are already in your list',
              ContentType.warning
          );
          setState(() {
            _isAlreadyAdded = true;
          });
        }else if(state is AddIngredientAlreadyFailed){
          _showNotification(
              context,
              'Failed to check its an added ingredient',
              ContentType.failure
          );
        } else if (state is AddIngredientFailure) {
          _showNotification(
              context,
              'Failed to add ingredients: ${state.error}',
              ContentType.failure
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is AddIngredientLoading;

        return SizedBox(
          child: ElevatedButton.icon(
            onPressed: isLoading || _isAlreadyAdded
                ? null
                : () =>  context.read<AddIngredientCubit>().addIngredients(widget.recipe),
            icon: _buildButtonIcon(isLoading, _isAlreadyAdded),
            label: Text(
              _getButtonLabel(_isAlreadyAdded),
              style: TextStyle(
                color: _isAlreadyAdded ? Colors.green : null,
              ),
            ),
            style: _getButtonStyle(_isAlreadyAdded),
          ),
        );
      },
    );
  }

  void _showNotification(
      BuildContext context,
      String message,
      ContentType contentType
      ) {
    DynamicNotificationWidget.showNotification(
      context: context,
      title: 'Ingredients',
      message: message,
      color: _getColorForContentType(contentType),
      contentType: contentType,
      inMaterialBanner: false,
    );
  }

  Color _getColorForContentType(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return Colors.green;
      case ContentType.failure:
        return Colors.red;
      case ContentType.warning:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Widget _buildButtonIcon(bool isLoading, bool isAdded) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    return Icon(
      isAdded ? Icons.check_circle : Icons.add_circle_outline,
      color: isAdded ? Colors.green : null,
    );
  }

  String _getButtonLabel(bool isAdded) {
    return isAdded ? 'Ingredients Added' : 'Add Ingredients';
  }

  ButtonStyle _getButtonStyle(bool isAdded) {
    return ElevatedButton.styleFrom(
      backgroundColor: isAdded
          ? Colors.green.shade50
          : AppColors.primary,
      foregroundColor: isAdded
          ? Colors.green
          : Colors.white,
      disabledBackgroundColor: isAdded
          ? Colors.green.shade50
          : Colors.grey.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  @override
  void dispose() {
    // If you're not reusing the cubit, you might want to close it
    // _addIngredientCubit.close();
    super.dispose();
  }
}