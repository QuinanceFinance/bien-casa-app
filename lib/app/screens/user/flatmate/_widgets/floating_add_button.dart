import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/_pages/add_flatmate_page.dart';
import '../home/_pages/add_flat_page.dart';

class FloatingAddButton extends StatelessWidget {
  final String routeName;
  final Map<String, dynamic>? arguments;

  const FloatingAddButton({super.key, required this.routeName, this.arguments});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 20,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to the specified route when clicked
            try {
              // Check which route we need to navigate to
              if (routeName == '/add-flat') {
                // For adding a new flat
                Get.to(
                  () => const AddFlatPage(),
                  transition: Transition.rightToLeft,
                );
              } else {
                // Default to adding a flatmate
                Get.to(
                  () => const AddFlatmatePage(),
                  transition: Transition.rightToLeft,
                );
              }
            } catch (e) {
              // Show error message if navigation fails
              Get.snackbar(
                'Navigation Error',
                'Could not navigate to the requested page.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.7),
                colorText: Colors.white,
              );
            }
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add_rounded, size: 35, color: Colors.black),
        ),
      ),
    );
  }
}
