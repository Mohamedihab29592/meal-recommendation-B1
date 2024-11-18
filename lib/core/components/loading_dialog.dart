 import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
   late AnimationController _rotationController;
   late AnimationController _scaleController;
   late Animation<double> _scaleAnimation;

   @override
   void initState() {
     super.initState();

     // Rotation Animation
     _rotationController = AnimationController(
       duration: const Duration(seconds: 1),
       vsync: this,
     )..repeat();

     // Scale Animation
     _scaleController = AnimationController(
       duration: const Duration(seconds: 1),
       vsync: this,
     );

     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
       CurvedAnimation(
         parent: _scaleController,
         curve: Curves.elasticOut,
       ),
     );

     // Repeat the scale animation
     _scaleController.repeat(reverse: true);
   }

   @override
   void dispose() {
     _rotationController.dispose();
     _scaleController.dispose();
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
             // Combine Rotation and Scale Animations
             ScaleTransition(
               scale: _scaleAnimation,
               child: RotationTransition(
                 turns: _rotationController,
                 child: SvgPicture.asset(
                   'assets/ic_loading.svg', // Prefer SVG for scalability
                   semanticsLabel: 'Loading Icon',
                   width: widget.iconSize ?? 100,
                   height: widget.iconSize ?? 100,
                   color: Theme.of(context).primaryColor, // Optional color tint
                 ),
               ),
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