import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController() {
    // Initialize controller
  }

  final RxString selectedRole = ''.obs;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpControllers = List.generate(4, (index) => TextEditingController());
  final RxBool isOtpComplete = false.obs;
  final RxString userType = ''.obs;
  final RxBool isPhoneValid = false.obs;
  final RxInt currentKYCStep = 0.obs;
  final RxString selectedDocumentType = ''.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isNewPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final referralCodeController = TextEditingController();
  final RxBool isReferralCodeValid = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void navigateToForgotPassword() {
    Get.toNamed(AppRoutes.FORGOT_PASSWORD);
  }

  void navigateToRestPassword() {
    Get.toNamed(AppRoutes.REST_PASSWORD);
  }

  void sendOTP() {
    if (phoneController.text.isNotEmpty) {
      // TODO: Implement actual OTP sending logic
      Get.toNamed(AppRoutes.OTP_VERIFICATION, arguments: phoneController.text);
    }
  }

  void resetPassword() {
    if (newPasswordController.text == confirmPasswordController.text) {
      // TODO: Implement actual password reset logic
      Get.snackbar(
        'Success',
        'Password reset successful',
        snackPosition: SnackPosition.TOP,
      );
      Get.toNamed(AppRoutes.SIGNIN);
    } else {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to OTP text changes
    for (var controller in otpControllers) {
      controller.addListener(() => _checkOtpComplete());
    }

    // Add listener for phone validation
    phoneController.addListener(updatePhoneButtonState);
  }

  @override
  void onClose() {
    phoneController.removeListener(updatePhoneButtonState); // Remove listener
    phoneController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    referralCodeController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  // Add this method to check if phone input is valid
  void updatePhoneButtonState() {
    isPhoneValid.value = phoneController.text.isNotEmpty;
    if (kDebugMode) {
      print('Phone valid: ${isPhoneValid.value}');
    }
  }

  void _checkOtpComplete() {
    isOtpComplete.value = otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
  }

  void selectRole(String role) {
    selectedRole.value = role;
    userType.value = role;
    Get.toNamed(AppRoutes.PHONE_VERIFICATION, arguments: role);
  }

  void verifyPhoneNumber() {
    if (phoneController.text.isNotEmpty) {
      // TODO: Implement actual phone verification
      Get.toNamed(AppRoutes.OTP_VERIFICATION, arguments: phoneController.text);
    }
  }

  void verifyOTP() {
    final otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 4) {
      if (otp == "1234") {
        // Check for correct OTP
        Get.snackbar(
          'Success',
          'OTP verification successful',
          snackPosition: SnackPosition.TOP,
        );
        Get.toNamed(AppRoutes.KYC_VERIFICATION);
      } else {
        Get.snackbar(
          'Error',
          'Invalid OTP code',
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  void resendOTP() {
    // TODO: Implement OTP resend functionality
    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to your phone number',
      snackPosition: SnackPosition.TOP,
    );
    Get.toNamed(AppRoutes.REST_PASSWORD);
  }

  void navigateToSignIn() {
    Get.toNamed(AppRoutes.SIGNIN);
  }

  void navigateToHomeOwner() {
    // For now just show a message since it's coming soon
    Get.snackbar(
      'Coming Soon',
      'Home Owner registration will be available soon!',
      snackPosition: SnackPosition.TOP,
    );
    // Uncomment when feature is ready
    // selectRole('Home Owner');
  }

  void navigateToRealtor() {
    selectRole('Realtor');
  }

  void navigateToUser() {
    try {
      selectRole('User');
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
      Get.snackbar(
        'Error',
        'Could not navigate to user registration.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void startKYCVerification() {
    currentKYCStep.value = 0;
    Get.toNamed(AppRoutes.KYC_VERIFICATION);
  }

  void selectDocumentType(String type) {
    selectedDocumentType.value = type;
  }

  void updateReferralCodeState() {
    isReferralCodeValid.value = referralCodeController.text.length >= 6;
  }

  void submitReferralCode() {
    if (isReferralCodeValid.value) {
      // TODO: Implement referral code verification logic
      Get.back(); // Close bottom sheet
      Get.snackbar(
        'Success',
        'Referral code applied successfully',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter a valid referral code',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void uploadDocument() {
    // TODO: Implement document upload logic
    currentKYCStep.value++;
  }

  void uploadSelfie() {
    // TODO: Implement selfie upload logic
    currentKYCStep.value++;
  }

  void uploadAddressProof() {
    // TODO: Implement address proof upload logic
    currentKYCStep.value++;
    completeKYCVerification();
  }

  void completeKYCVerification() {
    // TODO: Submit all collected KYC data to backend
    Get.snackbar(
      'Success',
      'KYC verification completed successfully',
      snackPosition: SnackPosition.TOP,
    );
    Get.offAllNamed(AppRoutes.kycSuccess);
  }
}
