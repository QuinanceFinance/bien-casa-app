import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding slides
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) => controller.currentPage.value = index,
            itemCount: controller.onboardingItems.length,
            itemBuilder: (context, index) {
              final item = controller.onboardingItems[index];
              return OnboardingPage(item: item);
            },
          ),

          // Skip button
          Positioned(
            top: 10,
            right: 20,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextButton(
                  onPressed: controller.skipOnboarding,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'ProductSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Using Get.width instead of MediaQuery
    final isSmallScreen = Get.height < 600;
    final screenHeight = Get.height;

    return Stack(
      children: [
        Column(
          children: [
            // Image at the top
            Expanded(
              flex: isSmallScreen ? 2 : 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(item.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Content Section
            Expanded(
              flex: isSmallScreen ? 2 : 3,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.06,
                  vertical: Get.height * 0.02,
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: Get.width * 0.1,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: Get.width * 0.04,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          final controller = Get.find<OnboardingController>();
                          controller.nextPage();
                        },
                        child: Image.asset(
                          item.buttonImage,
                          width: Get.width * 0.15,
                          height: Get.width * 0.15,
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
        // White gradient cloud overlay
        Positioned(
          bottom: screenHeight / (isSmallScreen ? 2 : 2.4),
          left: 0,
          right: 0,
          height: Get.height * 0.12,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withOpacity(0), Colors.white],
              ),
            ),
          ),
        ),
      ],
    );
  }
}