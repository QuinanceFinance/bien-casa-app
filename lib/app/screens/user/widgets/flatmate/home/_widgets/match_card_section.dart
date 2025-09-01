import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controllers/flatmate_controller.dart';
import '../../../../../../routes/app_routes.dart';

class MatchCardSection extends StatefulWidget {
  const MatchCardSection({super.key});

  @override
  State<MatchCardSection> createState() => _MatchCardSectionState();
}

class _MatchCardSectionState extends State<MatchCardSection> {
  late final FlatmateController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<FlatmateController>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Show loading indicator if no cards are available
    if (controller.recommendedFlatmates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: size.height * 0.6, // 60% of screen height
      child: Obx(() {
        // Calculate end index safely to prevent RangeError
        final startIndex = controller.currentIndex.value;
        final maxIndex = controller.recommendedFlatmates.length;
        final cardCount = controller.hasMoreCards ? 3 : 1;
        final endIndex = (startIndex + cardCount.clamp(1, 3)).clamp(0, maxIndex);
        
        // Make sure start index is valid and not greater than end index
        final validStartIndex = startIndex.clamp(0, maxIndex);
        final validEndIndex = endIndex > validStartIndex ? endIndex : validStartIndex;
        
        final cardsToShow = 
            (validStartIndex < maxIndex)
                ? controller.recommendedFlatmates
                    .sublist(validStartIndex, validEndIndex)
                    .asMap()
                    .entries
                    .toList()
                : [];

        return Stack(
          alignment: Alignment.center,
          children: [
            // Back cards (up to 2 cards behind)
            ...cardsToShow
                .sublist(0, cardsToShow.length - 1)
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  final cardIndex = controller.currentIndex.value + index;

                  return Positioned(
                    top: 20 + (index * 10),
                    child: GestureDetector(
                      onTap: () => _navigateToMatchDetail(card.value),
                      child: Transform.rotate(
                        angle: controller.getCardTilt(cardIndex),
                        child: _buildCard(
                          context,
                          data: card.value,
                          scale: 0.85 + (index * 0.05),
                        ),
                      ),
                    ),
                  );
                })
                .toList(),

            // Front card
            if (cardsToShow.isNotEmpty)
              GestureDetector(
                onTap: () => _navigateToMatchDetail(cardsToShow.last.value),
                child: Transform.rotate(
                  angle: controller.getCardTilt(
                    controller.currentIndex.value + cardsToShow.length - 1,
                  ),
                  child: _buildCard(
                    context,
                    data: cardsToShow.last.value,
                    isFront: true,
                  ),
                ),
              ),

            // Navigation arrows
            if (controller.currentIndex.value > 0)
              Positioned(
                left: 10,
                child: _buildNavButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: controller.previousCard,
                ),
              ),

            if (controller.hasMoreCards)
              Positioned(
                right: 10,
                child: _buildNavButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: controller.nextCard,
                ),
              ),
          ],
        );
      }),
    );
  }

  void _navigateToMatchDetail(Map<String, dynamic> data) {
    Get.toNamed(AppRoutes.MATCH_DETAIL, arguments: data);
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required Map<String, dynamic> data,
    double scale = 1.0,
    bool isFront = false,
  }) {
    final size = MediaQuery.of(context).size;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: size.width * 0.75, // Reduced from 0.85
        height: size.height * 0.45, // Reduced from 0.5
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _buildCardContent(data),
      ),
    );
  }

  Widget _buildCardContent(Map<String, dynamic> data) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // User Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            data['image'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: Colors.blue[100],
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              stops: const [0.4, 1.0],
            ),
          ),
        ),

        // User Info
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name and Age
              Row(
                children: [
                  Text(
                    '${data['name']}, ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    '${data['age']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // User Details
              Row(
                children: [
                  Text(
                    '${data['gender'] ?? 'Male'} | ${data['religion']} | ${data['occupation']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Product Sans Light',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      height: 1,
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Salary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        data['income'] ?? '₦0 - ₦0/yr',
                        style: const TextStyle(
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['location'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Product Sans Light',
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Removed action buttons as per requirements
}
