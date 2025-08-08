import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WelcomeController>();
    final isSmallScreen = Get.height < 600;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Image at the top with logo
              Expanded(
                flex: isSmallScreen ? 3 : 2,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/Mask_group_3.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Logo positioned at top left
                    Positioned(
                      top:
                          isSmallScreen ? Get.height * 0.04 : Get.height * 0.05,
                      left: Get.width * 0.06,
                      child: Container(
                        padding: EdgeInsets.all(Get.width * 0.02),
                        child: Image.asset(
                          'assets/image/logo_black.png',
                          width: Get.width * 0.12,
                          height: Get.width * 0.12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Expanded(
                flex: isSmallScreen ? 4 : 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.06,
                    vertical: Get.height * 0.01,
                  ),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome\nTo ',
                              style: TextStyle(
                                fontSize: Get.width * 0.09,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Bien Casa',
                              style: TextStyle(
                                fontSize: Get.width * 0.09,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        'Africa\'s most trusted real estate marketplace helping you find your dream home, co-live affordably, secure flexible property financing, or list your properties with ease.',
                        style: TextStyle(
                          fontSize: Get.width * 0.04,
                          fontFamily: 'ProductSans',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.03),
                      // Buttons
                      SizedBox(
                        width: double.infinity,
                        height: Get.height < 600 ? 50 : 70,
                        child: ElevatedButton(
                          onPressed: controller.navigateToSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: Get.width * 0.055,
                              fontFamily: 'ProductSans',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.016),
                      SizedBox(
                        width: double.infinity,
                        height: Get.height < 600 ? 50 : 70,
                        child: OutlinedButton(
                          onPressed: controller.navigateToSignIn,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.black,
                              width: Get.width * 0.007,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: Get.width * 0.055,
                              fontFamily: 'ProductSans',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // White gradient cloud overlay
          Positioned(
            bottom: Get.height / (isSmallScreen ? 1.75 : 2),
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
      ),
    );
  }
}
