import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../controllers/flatmate_match_controller.dart';
import '../../../../../routes/app_routes.dart';
import '../../../flatmate/_widgets/floating_add_button.dart';
import '../_widgets/flat_card.dart';

class FlatsPage extends StatelessWidget {
  const FlatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller to access flat data
    final controller = Get.find<FlatmateMatchController>();

    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headline for the page
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Browse available flat perfect for your flatmate by budget, location, interest etc.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'ProductSans',
                    color:  Color(0xff6B6B6B),
                  ),
                ),
              ),

              // Flats grid view
              Expanded(
                child: Obx(
                  () =>
                      controller.flats.isEmpty
                          ? _buildEmptyState()
                          : _buildFlatsGrid(controller),
                ),
              ),
            ],
          ),
        ),

        // Floating add button
        const FloatingAddButton(routeName: '/add-flat'),
      ],
    );
  }

  // Grid view of flat listings
  Widget _buildFlatsGrid(FlatmateMatchController controller) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75, // Taller than wide
      ),
      itemCount: controller.flats.length,
      itemBuilder: (context, index) {
        final flat = controller.flats[index];
        return FlatCard(flat: flat);
      },
    );
  }

  // Empty state when no flats are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/home.svg', // Replace with appropriate icon
            width: 80,
            height: 80,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Flats Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'We\'ll add more flats soon.\nCheck back later!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'ProductSans',
            ),
          ),
        ],
      ),
    );
  }
}

