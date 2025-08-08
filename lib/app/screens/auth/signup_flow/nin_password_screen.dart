import 'package:bien_casa/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class NINPasswordScreen extends StatefulWidget {
  const NINPasswordScreen({super.key});

  @override
  State<NINPasswordScreen> createState() => _NINPasswordScreenState();
}

class _NINPasswordScreenState extends State<NINPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isButtonEnabled = false.obs;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(validatePasswords);
    confirmPasswordController.addListener(validatePasswords);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validatePasswords() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    isButtonEnabled.value = password.length >= 8 && password == confirmPassword;
  }

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06,
              vertical: Get.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your\nPassword',
                  style: TextStyle(
                    fontSize: Get.width * 0.09,
                    fontFamily: 'ProductSans',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Text(
                  'Kindly enter your preferred password below to \nproceed with identity verification',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'ProductSans',
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                _buildInfoField('Full name', 'Victor Charles Ama'),
                _buildInfoField('Date of birth', '28/08/2005'),
                _buildInfoField('Gender', 'Male'),
                _buildInfoField('Nationality', 'Nigeria'),
                SizedBox(height: Get.height * 0.03),

                Obx(
                  () => TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      fillColor: Color(0xffF8F8F8),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffF8F8F8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffF8F8F8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffF8F8F8)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () => isPasswordVisible.toggle(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Text(
                  'Must be at least 8 characters',
                  style: TextStyle(
                    color: Color(0xffBDBDBD),
                    fontSize: Get.width * 0.035,
                    fontFamily: 'ProductSans',
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Obx(
                  () => TextField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Re-enter password',
                      fillColor: Color(0xffF8F8F8),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffF8F8F8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffF8F8F8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffF8F8F8)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () => isConfirmPasswordVisible.toggle(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Text(
                  'Both passwords must match',
                  style: TextStyle(
                    color: Color(0xffBDBDBD),
                    fontSize: Get.width * 0.035,
                    fontFamily: 'ProductSans',
                  ),
                ),

                SizedBox(height: Get.height * 0.06),
                SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 50 : 70,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          isButtonEnabled.value
                              ? () => Get.toNamed(AppRoutes.CHECK_READABILITY)
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBackgroundColor: Color(0xffF8F8F8),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: Get.width * 0.055,
                          fontFamily: 'ProductSans',
                          color: Colors.white,
                          // isButtonEnabled.value
                          //     ? Colors.white
                          //     : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xff6B6B6B),
              fontSize: 16.5,
              fontFamily: 'ProductSans',
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.5,
              fontFamily: 'ProductSans',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
