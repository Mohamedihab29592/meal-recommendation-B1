import 'package:flutter/cupertino.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class LoadingChatWidget extends StatelessWidget {
  const LoadingChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingDot(),
          SizedBox(width: 5),
          LoadingDot(),
          SizedBox(width: 5),
          LoadingDot(),
        ],
      ),
    );
  }
}

class LoadingDot extends StatefulWidget {
  const LoadingDot({super.key});

  @override
  LoadingDotState createState() => LoadingDotState();
}

class LoadingDotState extends State<LoadingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const Dot(),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppColors.primary, // Change to your desired color
        shape: BoxShape.circle,
      ),
    );
  }
}