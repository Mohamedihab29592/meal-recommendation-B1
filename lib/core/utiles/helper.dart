import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeEvent.dart';

import '../../features/gemini_integrate/data/Recipe.dart';
import '../../features/gemini_integrate/persentation/bloc/RecipeBloc.dart';
import '../../features/gemini_integrate/persentation/bloc/RecipeEvent.dart';
import '../../features/gemini_integrate/persentation/bloc/RecipeState.dart';
import '../../features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import '../../features/home/persentation/Widgets/filter_bottom_sheet.dart';
import '../components/dynamic_notification_widget.dart';
import '../components/loading_dialog.dart';
import '../services/di.dart';
import 'app_colors.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Disable closing the dialog by tapping outside
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}

Future<void> showDeleteDialog({
  required BuildContext context,
  required String mealId,
  required VoidCallback onSuccess,
}) async {
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.rightSlide,
    title: 'Delete Meal',
    desc: 'Are you sure you want to delete this meal?',
    btnCancelText: 'Cancel',
    btnOkText: 'Delete',
    btnCancelColor: Colors.grey,
    btnOkColor: Colors.red,
    btnCancelOnPress: () {
      // Optional: Perform actions on cancel
      HapticFeedback.lightImpact(); // Add subtle vibration feedback
    },
    btnOkOnPress: () async {
      try {
        print("Attempting to delete document with ID: $mealId");

        final homeBloc = BlocProvider.of<HomeBloc>(context);

         homeBloc.add(DeleteRecipeEvent(mealId));

        // Close loading dialog
        Navigator.of(context).pop();

        await _showSuccessSnackBar(context);

        onSuccess();

        // Haptic feedback for successful deletion
        HapticFeedback.mediumImpact();
      } catch (e) {
        Navigator.of(context).pop();

        // Log the error
        print("Error deleting document: $e");

        // Show detailed error message
        _showErrorSnackBar(context, e);
      }
    },
  ).show();
}

// Enhanced SnackBar for success
Future<void> _showSuccessSnackBar(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);

  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            'Meal deleted successfully!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

// Enhanced SnackBar for errors
void _showErrorSnackBar(BuildContext context, Object error) {
  final messenger = ScaffoldMessenger.of(context);

  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _getErrorMessage(error),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      action: SnackBarAction(
        label: 'Retry',
        textColor: Colors.white,
        onPressed: () {
          // Implement retry logic if needed
        },
      ),
    ),
  );
}

// Helper method to get user-friendly error message
String _getErrorMessage(Object error) {
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return 'You do not have permission to delete this meal.';
      case 'not-found':
        return 'The meal could not be found.';
      default:
        return 'An unexpected error occurred: ${error.message}';
    }
  }

  // Generic error handling
  return error.toString().length > 100
      ? 'Failed to delete meal. Please try again.'
      : error.toString();
}

void showNotification(BuildContext context, String message,
    ContentType contentType, Color color) {
  DynamicNotificationWidget.showNotification(
    context: context,
    title: "Recipe Management",
    message: message,
    color: color,
    contentType: contentType,
    inMaterialBanner: false,
  );
}

void showSaveConfirmationDialog(
    BuildContext parentContext, List<Recipe> recipesToSave) {
  showDialog(
    context: parentContext, // Use the parent context
    builder: (context) => AlertDialog(
      title: const Text('Save Recipes'),
      content: const Text('Do you want to save these recipes?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        BlocListener<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipesSaved) {
              Navigator.of(context).pop(); // Close dialog
              showNotification(context, 'Recipes saved successfully!',
                  ContentType.success, Colors.greenAccent);
            } else if (state is RecipeError) {
              Navigator.of(context).pop(); // Close dialog
              showNotification(
                  context,
                  'Failed to save recipes: ${state.message}',
                  ContentType.failure,
                  Colors.redAccent);
            }
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              print('Attempting to save recipes');
              parentContext
                  .read<RecipeBloc>()
                  .add(SaveRecipesEvent(recipesToSave));
            },
            child: const Text('Save'),
          ),
        ),
      ],
    ),
  );
}

void showCleanupOptions(BuildContext context, RecipeBloc recipeBloc) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.cleaning_services, color: Colors.blue),
              title: const Text('Complete Cleanup'),
              subtitle: const Text('Delete generated and archive old recipes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void showCleanupConfirmationDialog(BuildContext context, String title,
    String content, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}

List<Recipe> getCurrentRecipes(BuildContext context) {
  final recipeBloc = context.read<RecipeBloc>();
  final state = recipeBloc.state;

  if (state is RecipeLoaded) {
    return state.recipes;
  } else if (state is SavedRecipesLoaded) {
    return state.savedRecipes;
  } else if (state is RetrieveRecipesLoaded) {
    state.savedRecipes;
  }

  // If no recipes are available, return an empty list
  return recipeBloc.fetchedRecipes;
}

int safeParseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is String) {
// Debugging line to check the string value
    print('Parsing int from string: $value');
    return int.tryParse(value.replaceAll(RegExp(r'[^\d-]'), '')) ?? 0;
  }

  print('Unexpected type for int: ${value.runtimeType}'); // Debugging line
  return 0;
}

double safeParseDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;

  if (value is int) return value.toDouble();

  if (value is String) {
// Debugging line to check the string value
    print('Parsing double from string: $value');
    return double.tryParse(value.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0.0;
  }

  print('Unexpected type for double: ${value.runtimeType}'); // Debugging line
  return 0.0;
}

List<String> parseSafeStringList(dynamic value) {
  if (value == null) return [];

// If it's already a list of strings, return it
  if (value is List<String>) return value;

// If it's a list of dynamic, convert to strings
  if (value is List) {
    return value.map((e) => e?.toString() ?? '').toList();
  }

// If it's a single string, wrap it in a list
  if (value is String) return [value];

// Default to empty list
  return [];
}

String safeParseString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  return value.toString().trim().isEmpty ? defaultValue : value.toString();
}

String parseSafeString(dynamic value) {
  if (value == null) return 'N/A';
  return value.toString().trim().isEmpty ? 'N/A' : value.toString();
}

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BlocProvider.value(
        value: getIt<HomeBloc>(), child: const FilterBottomSheet()),
  );
}
