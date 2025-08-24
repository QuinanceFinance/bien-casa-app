import 'package:bien_casa/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class PassportVerificationScreen extends StatefulWidget {
  const PassportVerificationScreen({super.key});

  @override
  State<PassportVerificationScreen> createState() =>
      _PassportVerificationScreenState();
}

class _PassportVerificationScreenState
    extends State<PassportVerificationScreen> {
  final TextEditingController _passportController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _passportController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      // Standard Nigerian passport number is 8 characters
      isButtonEnabled = _passportController.text.length == 8;
    });
  }

  @override
  void dispose() {
    _passportController.dispose();
    super.dispose();
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
                  'Verify\nyour Identity',
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 40,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.proportional,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                Text(
                  'To verify your identity with your international \npassport, kindly enter your 8 digit passport \nnumber below.',
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Center(
                  child: SvgPicture.asset(
                    'assets/image/Password illustration.svg',
                    width: 262.3790588378906,
                    height: 272.0297546386719,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                TextField(
                  controller: _passportController,
                  keyboardType: TextInputType.text,
                  maxLength: 8,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    hintText: 'Enter your passport number',

                    counterText: '',
                    fillColor: Color(0xffF8F8F8),
                    hintStyle: TextStyle(
                      fontFamily: 'Product Sans Light',
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFBDBDBD),
                    ),
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
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Can't find my passport number?\n",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Product Sans',
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => _showPassportHelp(),
                            child: Text(
                              'Check here?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed:
                        isButtonEnabled
                            ? () => Get.toNamed(AppRoutes.NIN_PASSWORD)
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
                        fontFamily: 'Product Sans',
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
      ),
    );
  }
}

void _showPassportHelp() {
  final isSmallScreen = Get.height < 600;
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
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: Get.width * 0.035,
                fontFamily: 'Product Sans',
                fontWeight: FontWeight.w300,
                color: Colors.black,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text:
                      'Your passport number can be found on the data page of your international passport. It is typically located near the top of the page and consists of ',
                ),
                TextSpan(
                  text: '8 characters',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' (letters and numbers).'),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.03),
          Text(
            'Where to find your passport number',
            style: TextStyle(
              fontSize: Get.width * 0.045,
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Look at the data page of your passport\n• Find the field labeled "Passport No." or "Document No."\n• The number is typically in the format: A12345678\n• It may also appear at the bottom of the page in a machine-readable zone',
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.03),
          Text(
            'Important Notes',
            style: TextStyle(
              fontSize: Get.width * 0.045,
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• The passport number is different from the personal number\n• Make sure to enter all characters exactly as they appear\n• The number remains the same throughout the validity of your passport\n• Keep your passport information confidential',
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.04),
          Text(
            'If you cannot locate your passport number or have any issues, please contact the Nigeria Immigration Service.',
            style: TextStyle(
              fontSize: Get.width * 0.035,
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.w300,
              color: Colors.black,
              height: 1.5,
            ),
          ),
          SizedBox(height: Get.height * 0.03),
          SizedBox(
            width: double.infinity,
            height: isSmallScreen ? 45 : 70,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontFamily: 'Product Sans',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    ),
    isScrollControlled: true,
    enableDrag: true,
  );
}
