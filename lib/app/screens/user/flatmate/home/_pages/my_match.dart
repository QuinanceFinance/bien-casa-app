import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../controllers/flatmate_match_controller.dart';

class MyMatch extends StatelessWidget {
  MyMatch({super.key});

  // Use GetX controller instead of local state
  final FlatmateMatchController controller = Get.put(FlatmateMatchController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // Use Obx to make the GridView reactive to controller data changes
            child: Obx(
              () => controller.pendingMatches.isEmpty
                  ? _buildNoMatchesView()
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: controller.pendingMatches.length,
                      itemBuilder: (context, index) {
                        final match = controller.pendingMatches[index];
                        return _buildMatchCard(match);
                      },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Build view when there are no pending matches
  Widget _buildNoMatchesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/waiting.svg',  // Replace with appropriate icon
            width: 100,
            height: 100,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Pending Matches',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You don\'t have any pending match requests yet.\nCheck back later!',
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
  
  // Show bottom sheet with match action options
  void _showMatchActionSheet(Map<String, dynamic> match) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // Accept button (now first)
                  Expanded(
                    child: SizedBox(
                      height: 70, // Set height to 70px
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF29BCA2,
                          ).withValues(alpha: 0.1), // Teal color
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Get.back(); // Close bottom sheet
                          controller.acceptMatch(match);
                        },
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            fontFamily: 'ProductSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            color: Color(0xFF29BCA2),
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Decline button (now second)
                  Expanded(
                    child: SizedBox(
                      height: 70, // Set height to 70px
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(
                            0xFFDC3545,
                          ).withValues(alpha: 0.1), // Red color

                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Get.back(); // Close bottom sheet
                          controller.declineMatch(match);
                        },
                        child: const Text(
                          'Decline',
                          style: TextStyle(
                            fontFamily: 'ProductSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            color: Color(0xFFDC3545),
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    return GestureDetector(
      onTap: () => controller.viewMatchDetails(match),
      onLongPress: () => _showMatchActionSheet(match),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Profile Image
            Image.network(
              match['image'],
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
            ),

            // Bottom gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Info overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Age
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${match['name']}, ${match['age']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'ProductSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Gender | Religion | Occupation
                    Text(
                      '${match['gender']} | ${match['religion']} | ${match['occupation']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Budget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/naira.svg',
                              width: 10,
                              height: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 1.75),
                            Text(
                              match['budget'] ??
                                  match['income'], // Fallback to income for backward compatibility
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        // const SizedBox(height: 4),

                        // Location with icon
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 1.75),
                            Text(
                              match['location'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
