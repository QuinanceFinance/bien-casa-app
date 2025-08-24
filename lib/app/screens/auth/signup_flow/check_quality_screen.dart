import 'dart:io';
import 'dart:async';

import 'package:bien_casa/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CheckQualityScreen extends StatefulWidget {
  final XFile image;

  const CheckQualityScreen({super.key, required this.image});

  @override
  State<CheckQualityScreen> createState() => _CheckQualityScreenState();
}

class _CheckQualityScreenState extends State<CheckQualityScreen> {
  bool _showPinchIcon = false;
  Timer? _pinchIconTimer;

  @override
  void initState() {
    super.initState();
    _showPinchIconTemporarily();
  }

  @override
  void dispose() {
    _pinchIconTimer?.cancel();
    super.dispose();
  }

  void _showPinchIconTemporarily() {
    setState(() {
      _showPinchIcon = true;
    });

    _pinchIconTimer?.cancel();
    _pinchIconTimer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showPinchIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Identity doc', 'Selfie', '      Address'];
    final isSmallScreen = Get.height < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
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
                final isCompleted = index == 0; // First step completed
                return Expanded(
                  child: Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'Product Sans',
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check Quality',
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 40,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Make sure the information is seen clearly, with no blur or glare.',
                style: TextStyle(
                  fontFamily: 'Product Sans Light',
                  fontWeight: FontWeight.w300,
                  color: Color(0xff020202),
                  fontStyle: FontStyle.normal,
                  fontSize: 15,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Image.file(
                            File(widget.image.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      if (_showPinchIcon)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xff020202).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/zoom icon.png',
                                  width: Get.width * 0.1,
                                  height: Get.width * 0.1,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Pinch to zoom',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Product Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF8F8F8),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        side: BorderSide(color: Color(0xffF8F8F8), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Take Again',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 22,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the address verification screen
                        Get.toNamed(AppRoutes.ADDRESS_VERIFICATION);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 22,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
