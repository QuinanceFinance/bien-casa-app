import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/user_home_controller.dart';
import '../property_list_item.dart';

class RecentlyAddedScreen extends StatelessWidget {
  final UserHomeController _controller = Get.find<UserHomeController>();
  
  RecentlyAddedScreen({super.key});

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
          'Recently Added Properties',
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _controller.recentlyAddedProperties.length,
        itemBuilder: (context, index) {
          final property = _controller.recentlyAddedProperties[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PropertyListItem(
              imageUrl: property['images'] != null && (property['images'] as List).isNotEmpty
                  ? property['images'][0]
                  : '',
              name: property['name'] ?? '',
              address: property['address'] ?? '',
              price: property['price'] ?? '',
              size: property['size'] ?? '',
              type: property['type'] ?? '',
              onTap: () => _controller.navigateToPropertyDetail(property),
            ),
          );
        },
      ),
    );
  }
}
