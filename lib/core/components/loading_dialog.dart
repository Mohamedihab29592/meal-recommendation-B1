 import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';

 class LoadingDialog extends StatefulWidget {
   final String? message;
   final Color? backgroundColor;
   final Color? textColor;
   final double? iconSize;

   const LoadingDialog({
     super.key,
     this.message = 'Please wait',
     this.backgroundColor = Colors.white,
     this.textColor = Colors.black,
     this.iconSize,
   });

   @override
   LoadingDialogState createState() => LoadingDialogState();

   // Static method to show the dialog
   static void show(BuildContext context, {
     String? message,
     Color? backgroundColor,
     Color? textColor,
     double? iconSize,
   }) {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (context) => LoadingDialog(
         message: message,
         backgroundColor: backgroundColor,
         textColor: textColor,
         iconSize: iconSize,
       ),
     );
   }

   // Static method to dismiss the dialog
   static void dismiss(BuildContext context) {
     Navigator.of(context, rootNavigator: true).pop();
   }
 }

 class LoadingDialogState extends State<LoadingDialog>
     with SingleTickerProviderStateMixin {
   late AnimationController _animationController;

   @override
   void initState() {
     super.initState();
     _animationController = AnimationController(
       duration: const Duration(seconds: 2),
       vsync: this,
     )..repeat();
   }

   @override
   void dispose() {
     _animationController.dispose();
     super.dispose();
   }

   @override
   Widget build(BuildContext context) {
     return Dialog(
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(20.0),
       ),
       backgroundColor: widget.backgroundColor,
       child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             AnimatedBuilder(
               animation: _animationController,
               builder: (context, child) {
                 return Transform.rotate(
                   angle: _animationController.value * 2 * 3.14159,
                   child: Transform.scale(
                     scale: 1 + 0.2 * sin(_animationController.value * 2 * 3.14159),
                     child: Image.asset(
                       Assets.icLoading,
                       width: widget.iconSize ?? 100,
                       height: widget.iconSize ?? 100,
                       color: Theme.of(context).primaryColor,
                     ),
                   ),
                 );
               },
             ),
             const SizedBox(height: 20.0),
             Text(
               widget.message ?? 'Please wait',
               style: TextStyle(
                 fontSize: 16.0,
                 color: widget.textColor,
                 fontWeight: FontWeight.w500,
               ),
               textAlign: TextAlign.center,
             ),
             const SizedBox(height: 10.0),
             LinearProgressIndicator(
               backgroundColor: Colors.grey[300],
               valueColor: AlwaysStoppedAnimation<Color>(
                 Theme.of(context).primaryColor,
               ),
             ),
           ],
         ),
       ),
     );
   }
 }