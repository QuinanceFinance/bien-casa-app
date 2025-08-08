import 'package:bien_casa/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class KYCVerificationScreen extends StatelessWidget {
  const KYCVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final steps = ['Identity', 'Selfie', 'Address'];
    final isSmallScreen = Get.height < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps.length, (index) {
                final isActive = index == 0;
                return Expanded(
                  child: Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'ProductSans',
                      fontWeight: isActive ? FontWeight.w400 : FontWeight.w300,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(steps.length, (index) {
                  final isActive = index == 0; // Currently on first step
                  return Expanded(
                    child: Row(
                      children: [
                        if (index > 0)
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: isActive ? Colors.black : Colors.grey[300],
                            ),
                          ),
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color:
                                  isActive ? Colors.black : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child:
                              isActive
                                  ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                        if (index < steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: Colors.grey[300],
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 2.5),
          ],
        ),
        bottom: null,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: isSmallScreen ? 3 : 2,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/Mask_group_4.png'),
                          fit: BoxFit.cover,
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
                    vertical: Get.height * 0.02,
                  ),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First, let\'s get\nto know you',
                        style: TextStyle(
                          fontSize: Get.width * 0.09,
                          fontFamily: 'ProductSans',
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'ProductSans',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Please prepare one of the following documents \n',
                            ),
                            TextSpan(
                              text: 'Passport  |  National ID card',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Color(0xff6B6B6B),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Most people finish this step under 2 minutes",
                            style: TextStyle(
                              color: Color(0xff6B6B6B),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: Get.height < 600 ? 50 : 70,
                        child: ElevatedButton(
                          onPressed: () => _showDocumentSelection(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Select Document',
                            style: TextStyle(
                              fontSize: Get.width * 0.055,
                              fontFamily: 'ProductSans',
                              color: Colors.white,
                            ),
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
            bottom: Get.height / (isSmallScreen ? 2.03 : 2.3),
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

  Widget _buildStepIndicator(String title, bool isActive) {
    return Column(
      children: [
        Container(
          width: Get.width * 0.25,
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey[600],
            fontSize: 12,
            fontFamily: 'ProductSans',
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _showDocumentSelection() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.06,
          vertical: Get.height * 0.03,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose\nDocument Type',
              style: TextStyle(
                fontSize: Get.width * 0.09,
                fontFamily: 'ProductSans',
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Text(
              'Make sure the document includes a clear picture of your face',
              style: TextStyle(
                fontFamily: 'ProductSans',
                fontSize: Get.width * 0.04,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            SizedBox(height: Get.height * 0.03),
            Center(
              child: Image.asset(
                'assets/icons/Vector.png',
                alignment: Alignment.center,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: Get.height * 0.03),
            _buildDocumentOption(
              'International Passport',
              'International',
              'assets/icons/passport icon.png',
              () => Get.toNamed(AppRoutes.PASSPORT_VERIFICATION),
            ),
            SizedBox(height: Get.height * 0.015),
            _buildDocumentOption(
              'National ID',
              'National',
              'assets/icons/ID icon.png',
              () => Get.toNamed(AppRoutes.NIN_VERIFICATION),
            ),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  Widget _buildDocumentOption(
    String title,
    String subtitle,
    String iconPath,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.02,
          horizontal: Get.width * 0.04,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffF8F8F8), width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Get.width * 0.02),
              decoration: BoxDecoration(),
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: Get.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Get.width * 0.045,
                      fontFamily: 'ProductSans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: Get.width * 0.035,
                      fontFamily: 'ProductSans',
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
