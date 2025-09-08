import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/flatmate_match_controller.dart';
import 'flatmate_card.dart';

class AvailableCampaignsSection extends StatelessWidget {
  // Function to call when View All is tapped
  final VoidCallback onViewAllTap;

  const AvailableCampaignsSection({super.key, required this.onViewAllTap});

  @override
  Widget build(BuildContext context) {
    // Get the controller to access flatmate data
    final controller = Get.find<FlatmateMatchController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and View All button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                const Text(
                  'Available Campaigns',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'ProductSans',
                  ),
                ),

                // View all button
                GestureDetector(
                  onTap: onViewAllTap,
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'ProductSans',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal scrollable list of flatmates
          SizedBox(
            height: 390, // Set appropriate height for the cards
            child: Obx(() {
              // If no flatmates, show a message
              if (controller.matches.isEmpty) {
                return const Center(
                  child: Text(
                    'No campaigns available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'ProductSans',
                    ),
                  ),
                );
              }

              // Show horizontal list of flatmate cards
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount:
                    controller.matches.length > 30
                        ? 30
                        : controller.matches.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 255, // Set width for each card
                      child: FlatmateCard(flatmate: controller.matches[index]),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
