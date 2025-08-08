import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/user_home_controller.dart';
import '../featured_property_card.dart';
import 'dart:async';

class FeaturedPropertiesScreen extends StatefulWidget {
  const FeaturedPropertiesScreen({super.key});

  @override
  State<FeaturedPropertiesScreen> createState() =>
      _FeaturedPropertiesScreenState();
}

class _FeaturedPropertiesScreenState extends State<FeaturedPropertiesScreen> {
  final UserHomeController _controller = Get.find<UserHomeController>();
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < _controller.featuredProperties.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Featured Properties',
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              physics: const BouncingScrollPhysics(),
              itemCount: _controller.featuredProperties.length,
              itemBuilder: (context, index) {
                final property = _controller.featuredProperties[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: FeaturedPropertyCard(
                    imageUrl:
                        property['images'] != null &&
                                (property['images'] as List).isNotEmpty
                            ? property['images'][0]
                            : 'assets/image/house.png',
                    name: property['name'] ?? '',
                    address: property['address'] ?? '',
                    price: property['price'] ?? '',
                    size: property['size'] ?? '',
                    type: property['type'] ?? '',
                    currentIndex:
                        _currentPage, // Use _currentPage from parent instead of index
                    totalItems: _controller.featuredProperties.length,
                    onTap: () => _controller.navigateToPropertyDetail(property),
                  ),
                );
              },
            ),
          ),
          // Progress indicator
        ],
      ),
    );
  }
}
