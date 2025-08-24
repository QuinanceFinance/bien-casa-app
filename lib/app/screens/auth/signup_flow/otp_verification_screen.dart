import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final String correctOTP = "1234"; // Simulated correct OTP

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

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
              // SizedBox(height: Get.height * 0.04),
              Text(
                'Enter\nyour OTP',
                style: TextStyle(
                  fontSize: Get.width * 0.10,
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              RichText(
                text: TextSpan(
                  text: 'Kindly enter the OTP code sent to your phone ',
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'number ',
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    TextSpan(
                      text:
                          '***${phoneNumber.substring(phoneNumber.length - 3)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: ' below',
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    Color borderColor = const Color(0xffF8F8F8);
                    if (controller.isOtpComplete.value) {
                      borderColor =
                          controller.otpControllers.map((c) => c.text).join() ==
                                  correctOTP
                              ? const Color(0xff29BCA2)
                              : const Color(0xffDC3545);
                    }
                    return Container(
                      width: Get.width * 0.18,
                      height: Get.width * 0.18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: borderColor, width: 2.2),
                      ),
                      child: TextField(
                        controller: controller.otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: Get.width * 0.07,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                          controller.isOtpComplete();
                          if (controller.isOtpComplete.value) {
                            controller.verifyOTP();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              Spacer(),
              SizedBox(height: Get.width * 0.15),
              Center(
                child: GestureDetector(
                  onTap: () => controller.resendOTP(),
                  child: Column(
                    children: const [
                      Text(
                        'I didn\'t receive a code?',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Resend code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Product Sans',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.width * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
