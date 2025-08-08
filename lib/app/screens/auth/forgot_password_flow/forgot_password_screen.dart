import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final isSmallScreen = Get.height < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
          padding: EdgeInsets.only(left: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06,
            vertical: Get.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                padding: EdgeInsets.symmetric(vertical: Get.width * 0.02),
                child: Image.asset(
                  'assets/image/logo_black.png',
                  width: 50,
                  height: 50.2,
                ),
              ),

              SizedBox(height: Get.height * 0.04),

              // Title
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: Get.width * 0.10,
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: Get.height * 0.02),

              Text(
                'Enter your phone number to reset your password',
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontFamily: 'ProductSans',
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: Get.height * 0.06),

              // Phone Number Field
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
    fillColor: Color(0xFFF8F8F8),
                  hintText: 'Phone Number',
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/icons/nigeria_flag.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0xFFF8F8F8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0xFFF8F8F8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0xFFF8F8F8)),
    ),
                ),
              ),

              Spacer(),

              // Send OTP Button
              SizedBox(
                width: double.infinity,
                height: Get.height < 600 ? 50 : 70,
                child: ElevatedButton(
                  onPressed: controller.resendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Send OTP',
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
    );
  }
}
