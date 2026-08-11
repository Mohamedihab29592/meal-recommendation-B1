import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utiles/assets.dart';
import '../../../core/utiles/app_colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Onboarding content data
  final List<OnboardingContent> onboardingContents = [
    OnboardingContent(
      image: Assets.firstOnbordingLogo,
      title: 'Discover Delicious Recipes',
      description: 'Explore a world of culinary delights right at your fingertips.',
    ),
    OnboardingContent(
      image: Assets.secoundtOnbordingLogo,
      title: 'Personalized Cooking Guidance',
      description: 'Get step-by-step instructions tailored to your skill level.',
    ),
    OnboardingContent(
      image: Assets.thirdOnbordingLogo,
      title: 'Cook Like a Pro',
      description: 'Transform your kitchen into a gourmet restaurant experience.',
    ),
  ];

  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background and Border Containers
          _BackgroundContainers(height: height, width: width),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Skip Button
                _SkipButton(onPressed: _navigateToLogin),

                // Logo
                _AppLogo(height: height),

                const Spacer(),
                _ContentDescription(
                  currentPage: _currentPage,
                  onboardingContents: onboardingContents,
                  height: height,
                ),

                // Navigation Row
                _NavigationRow(
                  currentPage: _currentPage,
                  totalPages: onboardingContents.length,
                  pageController: _pageController,
                  onLoginPressed: _navigateToLogin,
                ),
              ],
            ),
          ),

          // Image PageView should be a direct child of Stack
          _ImagePageView(
            pageController: _pageController,
            onboardingContents: onboardingContents,
            height: height,
            width: width,
            currentPage: _currentPage,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
class _ContentDescription extends StatelessWidget {
  final int currentPage;
  final List<OnboardingContent> onboardingContents;
  final double height;

  const _ContentDescription({
    required this.currentPage,
    required this.onboardingContents,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              onboardingContents[currentPage].title,
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.02),
            Text(
              onboardingContents[currentPage].description,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
                letterSpacing: 0.5,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class _BackgroundContainers extends StatelessWidget {
  final double height;
  final double width;

  const _BackgroundContainers({
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Oval Background Container
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: height * 0.5,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(width * 0.5),
                bottomRight: Radius.circular(width * 0.5),
              ),
            ),
          ),
        ),

        // Circular Border Container
        Positioned(
          top: height * 0.28,
          left: width * 0.5 - 155, // Centered
          child: Container(
            height: 310,
            width: 310,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2.0
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SkipButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            'Skip',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  final double height;

  const _AppLogo({required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Image.asset(
        Assets.icSplash,
        height: height * 0.1,
      ),
    );
  }
}

class _ImagePageView extends StatelessWidget {
  final PageController pageController;
  final List<OnboardingContent> onboardingContents;
  final double height;
  final double width;
  final int currentPage;
  final Function(int) onPageChanged;

  const _ImagePageView({
    required this.pageController,
    required this.onboardingContents,
    required this.height,
    required this.width,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height * 0.275 ,
      left: width * 0.5 - 150,
      child: SizedBox(
        height: 350,
        width: 300,
        child: PageView.builder(
          controller: pageController,
          itemCount: onboardingContents.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 125,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(onboardingContents[index].image),
              ),
            );
          },
        ),
      ),
    );
  }
}
class _NavigationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final VoidCallback onLoginPressed;

  const _NavigationRow({
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicators
          _PageIndicators(
            currentPage: currentPage,
            totalPages: totalPages,
          ),

          // Next/Login Button
          _NavigationButton(
            currentPage: currentPage,
            totalPages: totalPages,
            pageController: pageController,
            onLoginPressed: onLoginPressed,
          ),
        ],
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicators({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalPages,
            (index) => AnimatedContainer(
          margin: const EdgeInsets.only(right: 10),
          width: 25,
          height: 10,
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.primary
                : Colors.black12,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final VoidCallback onLoginPressed;

  const _NavigationButton({
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return currentPage != totalPages - 1
        ? TextButton(
      onPressed: () {
        pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.decelerate,
        );
      },
      child: const Text(
        "Next",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: AppColors.primary,
        ),
      ),
    )
        : TextButton(
      onPressed: onLoginPressed,
      child: const Text(
        "Login",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}