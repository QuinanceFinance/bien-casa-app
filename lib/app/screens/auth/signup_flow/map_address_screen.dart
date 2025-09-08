import 'dart:io';

import 'package:bien_casa/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../config/app_constants.dart';

class MapAddressScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const MapAddressScreen({super.key, this.initialPosition});

  @override
  State<MapAddressScreen> createState() => _MapAddressScreenState();
}

class _MapAddressScreenState extends State<MapAddressScreen> {
  final String _locationIqApiKey = AppConstants.locationIqApiKey;
  final MapController _mapController = MapController();
  late LatLng _currentPosition;
  final List<Marker> _markers = [];
  String _currentAddress = '';
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  List<String> _addressSuggestions = [];
  bool _showSuggestions = false;
  bool _hasValidAddress = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    // Initialize with a default position that will be updated
    _currentPosition = const LatLng(
      9.0820,
      8.6753,
    ); // Default to Nigeria's center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialPosition != null) {
        _currentPosition = widget.initialPosition!;
        _getAddressFromLatLng(_currentPosition);
      } else {
        _getCurrentLocation();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Location request timed out'),
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });

        // Move map to current location
        _mapController.move(_currentPosition, 15.0);

        // Get address from coordinates
        await _getAddressFromLatLng(_currentPosition);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Location Error',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
          _hasValidAddress = true;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get address: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _onMapTap(LatLng point) {
    setState(() {
      _currentPosition = point;
    });
    _getAddressFromLatLng(point);
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) {
      setState(() {
        _addressSuggestions = [];
        _showSuggestions = false;
        _hasValidAddress = false;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.locationiq.com/v1/autocomplete.php?key=$_locationIqApiKey&q=${Uri.encodeComponent(query)}&countrycodes=ng&limit=5',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _addressSuggestions =
              data.map((place) => place['display_name'].toString()).toList();
          if (_addressSuggestions.isEmpty) {
            _addressSuggestions = [query]; // Use user input as suggestion
          }
          _showSuggestions = true;
          _isSearching = false;
        });
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print('LocationIQ autocomplete error: $e');
      setState(() {
        _addressSuggestions = [query]; // Use user input as suggestion on error
        _showSuggestions = true;
        _isSearching = false;
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          setState(() {
            _capturedImage = photo;
          });
        }
      } else {
        Get.snackbar(
          'Permission Denied',
          'Camera permission is required to take a picture',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take picture: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showAddressDetailsUtilityBill(String address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showAddressDetailsSheet(address);
                          },
                        ),
                        const Text(
                          'Update your address',
                          style: TextStyle(
                            fontFamily: 'ProductSans',
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0,
                            color: Colors.black,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.offAllNamed(AppRoutes.kycSuccess);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ProductSans',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'ProductSans Light',
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        color: Colors.black,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text:
                              'Ensure that the document provided is one of the following ',
                        ),
                        TextSpan(
                          text: 'Utility bill',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' | '),
                        TextSpan(
                          text: 'Bank statement',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' and your address is well represented'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      icon: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Colors.black,
                        size: 32,
                      ),
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        fillColor: Colors.white,
                      ),

                      hint: Text(
                        'Utility bill',
                        style: TextStyle(
                          fontFamily: 'ProductSans Light',
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          leadingDistribution:
                              TextLeadingDistribution.proportional,
                          letterSpacing: 0,
                          color: Colors.black,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'utility',
                          child: Center(
                            child: Text(
                              'Utility bill',
                              style: TextStyle(
                                fontFamily: 'ProductSans Light',
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                leadingDistribution:
                                    TextLeadingDistribution.proportional,
                                letterSpacing: 0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'bank',
                          child: Center(
                            child: Text(
                              'Bank statement',
                              style: TextStyle(
                                fontFamily: 'ProductSans Light',
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                leadingDistribution:
                                    TextLeadingDistribution.proportional,
                                letterSpacing: 0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: InkWell(
                      onTap: _takePicture,
                      child: Center(
                        child:
                            _capturedImage != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    File(_capturedImage!.path),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                )
                                : Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                  color: Colors.black,
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 94),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.black, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'This is also my mailing address',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'ProductSans Light',
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.offAllNamed(AppRoutes.kycSuccess);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
    );
  }

  void _showAddressDetailsSheet(String address) {
    // Parse the address components
    List<String> addressParts = address.split(', ');
    if (addressParts.isNotEmpty) {
      _streetNameController.text = addressParts[0];
      if (addressParts.length > 1) {
        _cityController.text = addressParts[1];
      }
      if (addressParts.length > 2) {
        _stateController.text = addressParts[2];
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Update your address',
                            style: TextStyle(
                              fontFamily: 'ProductSans',
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                              leadingDistribution: TextLeadingDistribution.even,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.offAllNamed(AppRoutes.kycSuccess);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ProductSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                          height: 20 / 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _houseNoController,
                  decoration: InputDecoration(
                    hintText: 'House No.',
                    hintStyle: TextStyle(
                      fontFamily: 'ProductSans Light',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      height: 1,
                      color: Color(0xffBDBDBD),
                      letterSpacing: 0,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
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
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _streetNameController,
                  decoration: InputDecoration(
                    hintText: 'Street Name',
                    hintStyle: TextStyle(
                      fontFamily: 'ProductSans Light',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      height: 1,
                      color: Color(0xffBDBDBD),
                      letterSpacing: 0,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
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
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'City/Town',
                    hintStyle: TextStyle(
                      fontFamily: 'ProductSans Light',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      height: 1,
                      color: Color(0xffBDBDBD),
                      letterSpacing: 0,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
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
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    hintText: 'State',
                    hintStyle: TextStyle(
                      fontFamily: 'ProductSans Light',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      height: 1,
                      color: Color(0xffBDBDBD),
                      letterSpacing: 0,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
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
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(
                    hintText: 'Postal Code',
                    hintStyle: TextStyle(
                      fontFamily: 'ProductSans Light',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      height: 1,
                      color: Color(0xffBDBDBD),
                      letterSpacing: 0,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
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
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    hintText: 'Country',
                    hintStyle: TextStyle(
                      fontFamily: 'ProductSans Light',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      height: 1,
                      color: Color(0xffBDBDBD),
                      letterSpacing: 0,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
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
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.black, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'This is also my mailing address',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'ProductSans Light',
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddressDetailsUtilityBill(_currentAddress);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
    );
  }

  Future<void> _selectSuggestion(String address) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.locationiq.com/v1/search.php?key=$_locationIqApiKey&q=${Uri.encodeComponent(address)}&format=json&limit=1',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final place = data.first;
          final newPosition = LatLng(
            double.parse(place['lat']),
            double.parse(place['lon']),
          );

          setState(() {
            _currentPosition = newPosition;
            _currentAddress = place['display_name'];
            _showSuggestions = false;
            _searchController.text = place['display_name'];
            _hasValidAddress = true;
          });

          _mapController.move(newPosition, 15.0);
        }
      } else {
        throw Exception('Failed to locate address');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to locate address: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Identity doc', 'Selfie', '      Address'];
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
      ),
      body: Stack(
        children: [
          if (_isLoading)
            Container(
              // color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
          Column(
            children: [
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition,
                    initialZoom: 15,
                    onTap: (tapPosition, point) => _onMapTap(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.bien_casa',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentPosition,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Enter full address',
                            style: TextStyle(
                              fontFamily: 'ProductSans',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 18,
                              leadingDistribution: TextLeadingDistribution.even,
                              letterSpacing: 0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.offAllNamed(AppRoutes.kycSuccess);
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 15,
                                color: Colors.black,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'ProductSans Light',
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            letterSpacing: 0,
                          ),
                          hintText: '101 Jesse Jackson St. Abuja 900231',
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
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder:
                                (context) => DraggableScrollableSheet(
                                  initialChildSize: 0.9,
                                  minChildSize: 0.5,
                                  maxChildSize: 0.9,
                                  builder:
                                      (context, scrollController) => Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: TextField(
                                              autofocus: true,
                                              controller: _searchController,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 20,
                                                    ),
                                                hintText:
                                                    'Start typing to see recommendations',
                                                hintStyle: TextStyle(
                                                  fontFamily:
                                                      'ProductSans Light',
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 18,
                                                  height: 1,
                                                  color: Color(0xff6B6B6B),
                                                  letterSpacing: 0,
                                                ),
                                                fillColor: Color(0xffF8F8F8),
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Color(0xffF8F8F8),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xffF8F8F8,
                                                        ),
                                                      ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xffF8F8F8,
                                                        ),
                                                      ),
                                                    ),
                                                suffixIcon:
                                                    _isSearching
                                                        ? Container(
                                                          width: 18,
                                                          height: 18,
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                  Color
                                                                >(
                                                                  Color(
                                                                    0xff6B6B6B,
                                                                  ),
                                                                ),
                                                          ),
                                                        )
                                                        : null,
                                              ),
                                              onChanged:
                                                  (value) =>
                                                      _searchAddress(value),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              controller: scrollController,
                                              itemCount:
                                                  _addressSuggestions.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  leading: Icon(
                                                    Icons.location_on,
                                                    color: Color(0xff6B6B6B),
                                                  ),
                                                  title: Text(
                                                    _addressSuggestions[index],
                                                    style: TextStyle(
                                                      color: Color(0xff6B6B6B),
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'ProductSans Light',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _showAddressDetailsSheet(
                                                      _addressSuggestions[index],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                          );
                        },
                      ),
                      SizedBox(height: 6),
                      SizedBox(height: 10),
                      if (_showSuggestions == false)
                        Text(
                          "Start typing to see recommendations",
                          style: TextStyle(
                            fontFamily: 'ProductSans Light',
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff6B6B6B),
                          ),
                        ),
                      SizedBox(height: 10),
                      if (_showSuggestions && _searchController.text.isNotEmpty)
                        Container(
                          constraints: BoxConstraints(maxHeight: 200),
                          padding: EdgeInsets.only(left: 5),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _addressSuggestions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: Color(0xff6B6B6B),
                                ),
                                title: Text(
                                  _addressSuggestions[index],
                                  style: TextStyle(
                                    color: Color(0xff6B6B6B),
                                    fontSize: 16,
                                    fontFamily: 'ProductSans',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),

                                onTap:
                                    () => _selectSuggestion(
                                      _addressSuggestions[index],
                                    ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
