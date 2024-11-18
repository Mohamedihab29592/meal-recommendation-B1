 import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import '../components/loading_dialog.dart';
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
       // Show loading indicator
       showDialog(
         context: context,
         barrierDismissible: false,
         builder: (context) => const Center(
           child: CircularProgressIndicator(
             valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
           ),
         ),
       );

       try {
         print("Attempting to delete document with ID: $mealId");

         final homeCubit = BlocProvider.of<HomeCubit>(context);

         // Perform delete operation
         await homeCubit.deleteRecipe(mealId);

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