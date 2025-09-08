import 'package:bien_casa/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class NINVerificationScreen extends StatefulWidget {
  const NINVerificationScreen({super.key});

  @override
  State<NINVerificationScreen> createState() => _NINVerificationScreenState();
}

class _NINVerificationScreenState extends State<NINVerificationScreen> {
  final TextEditingController _ninController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _ninController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      isButtonEnabled = _ninController.text.length == 11;
    });
  }

  @override
  void dispose() {
    _ninController.dispose();
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
                    fontFamily: 'ProductSans',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 40,
                    height: 1.2,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'To verify your identity with your NIN, kindly enter your 11-digit NIN number below.',
                  style: TextStyle(
                    fontFamily: 'ProductSans Light',
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Center(
                  child: Image.asset(
                    'assets/image/icon 1.png',
                    width: 280,
                    height: 280,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                TextField(
                  controller: _ninController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    hintText: 'Enter your 11-digit NIN',
                    counterText: '',
                    fillColor: Color(0xffF8F8F8),
                    hintStyle: TextStyle(
                      fontFamily: 'ProductSans Light',
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
                          text: "Can't find my NIN no.?\n",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'ProductSans',
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => _showNINCheckMethods(),
                            child: Text(
                              'Check here?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.w700,
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
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                        height: 40 / 22,
                        letterSpacing: 0,
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

void _showNINCheckMethods() {
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
                fontFamily: 'ProductSans',
                fontWeight: FontWeight.w300,
                color: Colors.black,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text:
                      'To check your National Identification Number (NIN) using the USSD code, you can dial ',
                ),
                TextSpan(
                  text: '*346#',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ' on your phone. You can also check your NIN using the ',
                ),
                TextSpan(
                  text: 'NIMC mobile app',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', the '),
                TextSpan(
                  text: 'NIMC website',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', or the '),
                TextSpan(
                  text: 'NIN Status Portal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.03),
          Text(
            'Steps to check your NIN using the USSD code',
            style: TextStyle(
              fontSize: Get.width * 0.045,
              fontFamily: 'ProductSans',
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
                  '• Dial *346#\n• Select "NIN Retrieval" by typing "1"\n• Follow the steps displayed on your screen\n• Provide the required inputs',
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    fontFamily: 'ProductSans',
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
            'Other ways to check your NIN',
            style: TextStyle(
              fontSize: Get.width * 0.045,
              fontFamily: 'ProductSans',
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
                  '• Visit any NIMC office\n• Download the NIMC mobile app and follow the instructions\n• Visit the NIN Status Portal by visiting https://nin.mtn.ng/nin/status\n• Visit MTN\'s corporate website https://mtn.ng/\n• Use the myMTNApp\n• Use Zigi',
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    fontFamily: 'ProductSans',
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
            'The NIN is an 11-digit number that is randomly assigned to an individual when they enroll into the National Identity Database (NIDB).',
            style: TextStyle(
              fontSize: Get.width * 0.035,
              fontFamily: 'ProductSans',
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
                  fontFamily: 'ProductSans',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    enableDrag: true,
  );
}
