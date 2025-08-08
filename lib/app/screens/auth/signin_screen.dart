import 'package:bien_casa/app/routes/app_routes.dart';
import 'package:bien_casa/app/screens/docs/privacy_policy_screen.dart';
import 'package:bien_casa/app/screens/docs/terms_of_service_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
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
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                'Welcome Back',
                style: TextStyle(
                  fontSize: Get.width * 0.10,
                  fontFamily: 'ProductSans',
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: Get.height * 0.02),

              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontFamily: 'ProductSans',
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: Get.height * 0.06),

              // Phone Number Field
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  filled: true,
                  fillColor: Color(0xFFF8F8F8),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    color: Color(0xFFF8F8F8),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.02),

              // Password Field
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF8F8F8),
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.navigateToForgotPassword,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'ProductSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              Spacer(),
 // Sign In Button
              SizedBox(
                width: double.infinity,
                height: Get.height < 600 ? 50 : 70,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Form is valid, proceed with login
                      Get.toNamed(AppRoutes.SIGNIN_OTP_VERIFICATION, arguments: controller.phoneController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: Get.width * 0.055,
                      fontFamily: 'ProductSans',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

           
              SizedBox(height: Get.height * 0.04),

                // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'ProductSans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () => Get.toNamed(AppRoutes.SIGNUP),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


// Terms and Privacy
              Padding(
                padding: EdgeInsets.only(
                  bottom: Get.height * 0.02,
                  top: Get.height * 0.02,
                ),
                child: Text.rich(
                  TextSpan(
                    text: 'By using Bien Casa you agree to our ',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'ProductSans',
                      color: Colors.black54,
                    ),
                    children: [
                      TextSpan(
                        text: 'Term of Service',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => Get.to(
                                    () => const TermsOfServiceScreen(),
                                  ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () =>
                                      Get.to(() => const PrivacyPolicyScreen()),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
              SizedBox(height: Get.height * 0.02),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
