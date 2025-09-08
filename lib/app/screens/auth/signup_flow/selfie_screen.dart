import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/app_routes.dart';

class SelfieScreen extends StatelessWidget {
  const SelfieScreen({super.key});

  Future<void> _takeSelfie() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          Get.toNamed(AppRoutes.CHECK_QUALITY, arguments: photo);
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to take selfie',
          snackPosition: SnackPosition.TOP,
        );
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant camera permission to take a selfie',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Identity doc', 'Selfie', '      Address'];
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
                final isActive = index == 1; // Selfie is active
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
                  // First step completed, second step active
                  final isCompleted = index == 0;
                  final isActive = index == 1;
                  return Expanded(
                    child: Row(
                      children: [
                        if (index > 0)
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color:
                                  isCompleted
                                      ? Colors.black
                                      : isActive
                                      ? Colors.black
                                      : Colors.grey[300]!,
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
                                  isActive || isCompleted
                                      ? Colors.black
                                      : Colors.grey[300]!,
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
                                  : isCompleted
                                  ? Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 10,
                                      color: Colors.black,
                                    ),
                                  )
                                  : null,
                        ),
                        if (index < steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color:
                                  isCompleted
                                      ? Colors.black
                                      : Colors.grey[300]!,
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
                          image: AssetImage('assets/image/Mask group 5.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Expanded(
                flex: isSmallScreen ? 3 : 2,
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
                        'Take a selfie',
                        style: TextStyle(
                          fontFamily: 'Product SansBlack',
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                          fontSize: 40,
                          color: Color(0xff1E1E1E),
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'The image should be clear and have your face fully inside the frame',
                        style: TextStyle(
                          fontFamily: 'Product SansLight',
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                          color: Color(0xff020202),
                          fontSize: 15.0,
                          height: 1.0,
                          letterSpacing: 0.0,
                        ),
                      ),
                      SizedBox(height: 64),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 20,
                            color: Color(0xff6B6B6B),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Most people finish this step under 1 minutes",
                            style: TextStyle(
                              fontFamily: 'Product SansLight',
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              fontSize: 15,
                              letterSpacing: 0,
                              color: Color(0xff6B6B6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: _takeSelfie,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Take a selfie',
                            style: TextStyle(
                              fontFamily: 'ProductSans',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // White gradient cloud overlay
          Positioned(
            bottom: Get.height / (isSmallScreen ? 2.33 : 2.25),
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
