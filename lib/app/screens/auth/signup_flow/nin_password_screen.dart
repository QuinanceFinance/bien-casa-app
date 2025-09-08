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
                    fontFamily: 'ProductSans',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 40,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.proportional,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Kindly enter your preferred password below to \nproceed with identity verification',
                  style: TextStyle(
                    fontFamily: 'ProductSans Light',
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.proportional,
                    color: Color(0xff020202),
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 36),
                _buildInfoField('Full name', 'Victor Charles Ama'),
                _buildInfoField('Date of birth', '28/08/2005'),
                _buildInfoField('Gender', 'Male'),
                _buildInfoField('Nationality', 'Nigeria'),
                SizedBox(height: 36),

                Obx(
                  () => Container(
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                          fontFamily: 'ProductSans Light',
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          letterSpacing: 0,
                          color: Color(0xffBDBDBD),
                        ),
                        fillColor: Color(0xffF8F8F8),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffF8F8F8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffF8F8F8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
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
                ),
                SizedBox(height: 10),
                Text(
                  'Must be at least 8 characters',
                  style: TextStyle(
                    color: Color(0xffBDBDBD),
                    fontFamily: 'ProductSans Light',
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => Container(
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: !isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Re-enter password',
                        hintStyle: TextStyle(
                          fontFamily: 'ProductSans Light',
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          letterSpacing: 0,
                          color: Color(0xffBDBDBD),
                        ),
                        fillColor: Color(0xffF8F8F8),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffF8F8F8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffF8F8F8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
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
                ),
                SizedBox(height: 10),
                Text(
                  'Both passwords must match',
                  style: TextStyle(
                    color: Color(0xffBDBDBD),
                    fontFamily: 'ProductSans Light',
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    letterSpacing: 0,
                  ),
                ),

                SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 70,
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
                          fontFamily: 'ProductSans',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 22,
                          letterSpacing: 0,
                          color: Colors.white,
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
              fontFamily: 'Product SansLight',
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              fontSize: 18.0,
              letterSpacing: 0.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'ProductSans Light',
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              fontSize: 18.0,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
