 import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key});

  @override
  LoadingDialogState createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // This makes the animation repeat indefinitely.
  }

  @override
  void dispose() {
    // Dispose of the controller when no longer needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rotating the SVG asset using RotationTransition
            RotationTransition(
              turns: _controller, // The controller drives the rotation
              child: SvgPicture.asset(
                'assets/ic_loading.svg',
                semanticsLabel: 'Loading Icon',
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'please wait',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}