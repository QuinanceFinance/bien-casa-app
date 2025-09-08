import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/app_routes.dart';
import 'map_address_screen.dart';

class AddressVerificationScreen extends StatefulWidget {
  const AddressVerificationScreen({super.key});

  @override
  State<AddressVerificationScreen> createState() =>
      _AddressVerificationScreenState();
}

class _AddressVerificationScreenState extends State<AddressVerificationScreen> {
  bool _isLoading = false;

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
                final isActive = index == 2; // Address is active
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
                  // First two steps completed, third step active
                  final isCompleted = index < 2;
                  final isActive = index == 2;
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
                          image: AssetImage('assets/image/Mask_group_6.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Expanded(
                flex: isSmallScreen ? 4 : 2,
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
                        "Let's verify\nyour address",
                        style: TextStyle(
                          fontFamily: 'ProductSans Black',
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                          fontSize: 40,
                          leadingDistribution:
                              TextLeadingDistribution.proportional,
                          letterSpacing: 0,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'ProductSans Light',
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            letterSpacing: 0,
                            color: Color(0xff020202),
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Please prepare one of the following documents \n',
                            ),
                            TextSpan(
                              text: 'Utility bill  |  Bank statement',
                              style: TextStyle(
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 15,
                                letterSpacing: 0,
                                color: Color(0xff020202),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 62),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Color(0xff6B6B6B),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Most people finish this step under 1 minute",
                            style: TextStyle(
                              fontFamily: 'ProductSans Light',
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0,
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
                          onPressed:
                              _isLoading
                                  ? null
                                  : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      // Request location permission before navigating
                                      var status =
                                          await Permission.location.request();
                                      if (status.isGranted) {
                                        try {
                                          // Get current position
                                          Position position =
                                              await Geolocator.getCurrentPosition(
                                                desiredAccuracy:
                                                    LocationAccuracy.high,
                                              );

                                          final result = await Get.to(
                                            () => MapAddressScreen(
                                              initialPosition: LatLng(
                                                position.latitude,
                                                position.longitude,
                                              ),
                                            ),
                                          );

                                          if (result != null) {
                                            // Handle the returned address data
                                            final address = result['address'];
                                            final latitude = result['latitude'];
                                            final longitude =
                                                result['longitude'];

                                            // You can store this data or use it for the next step
                                            debugPrint(
                                              'Selected address: $address',
                                            );
                                            debugPrint(
                                              'Coordinates: $latitude, $longitude',
                                            );

                                            // Navigate to the next screen or continue verification process
                                            Get.toNamed(AppRoutes.MAP_ADDRESS);
                                          }
                                        } catch (e) {
                                          Get.snackbar(
                                            'Error',
                                            'Failed to get current location: $e',
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      } else {
                                        Get.snackbar(
                                          'Permission Denied',
                                          'Location permission is required to get your current location',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    'Verify your address',
                                    style: TextStyle(
                                      fontFamily: 'ProductSans',
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 22,
                                      height: 1,
                                      color: Colors.white,
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
            bottom: Get.height / (isSmallScreen ? 2.03 : 2.3),
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
