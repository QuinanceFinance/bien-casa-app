import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../controllers/flatmate_match_controller.dart';
import '../../../flatmate/_widgets/floating_add_button.dart';
import '../../../../../routes/app_routes.dart';
import '../_widgets/flatmate_card.dart';

class Flatmates extends StatefulWidget {
  const Flatmates({super.key});

  @override
  State<Flatmates> createState() => _FlatmatesState();
}

class _FlatmatesState extends State<Flatmates> {
  // Get controller
  final FlatmateMatchController controller =
      Get.find<FlatmateMatchController>();

  // Track join request status for each flatmate
  final Map<String, bool> _joinRequestStatus = {};

  // Show campaign details bottom sheet
  void _showCampaignDetails(Map<String, dynamic> flatmate) {
    // Generate a unique ID for this flatmate if needed
    String flatmateId = flatmate['id'] ?? flatmate['name'];

    // Show bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Campaign header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Campaign Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ProductSans',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Host section
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  flatmate['image'] ??
                                      'https://randomuser.me/api/portraits/men/45.jpg',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${flatmate['name']}, ${flatmate['age']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ProductSans',
                                    ),
                                  ),
                                  Text(
                                    flatmate['occupation'] ?? 'Professional',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'ProductSans',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Campaign info
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Budget
                            _buildInfoRow(
                              title: 'Budget',
                              value: flatmate['budget'] ?? '₦550k - ₦600k/yr',
                              icon: Icons.account_balance_wallet,
                            ),
                            const SizedBox(height: 16),

                            // Location
                            _buildInfoRow(
                              title: 'Location',
                              value: flatmate['location'] ?? 'Abuja',
                              icon: Icons.location_on,
                            ),
                            const SizedBox(height: 16),

                            // Religion
                            _buildInfoRow(
                              title: 'Religion',
                              value: flatmate['religion'] ?? 'Not specified',
                              icon: Icons.church,
                            ),
                            const SizedBox(height: 16),

                            // About
                            const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ProductSans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              flatmate['bio'] ??
                                  'Looking for like-minded individuals to share an apartment with in ${flatmate['location'] ?? 'Abuja'}. I am a ${flatmate['occupation'] ?? 'professional'} with a budget of ${flatmate['budget'] ?? '₦550k - ₦600k/yr'}.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                height: 1.5,
                                fontFamily: 'ProductSans',
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Preferences
                            const Text(
                              'Preferences',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ProductSans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildPreferenceChip('Non-smoker'),
                                _buildPreferenceChip('Quiet environment'),
                                _buildPreferenceChip('Pet friendly'),
                                _buildPreferenceChip('Clean'),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),

                    // Join button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setModalState(() {
                              _joinRequestStatus[flatmateId] = true;
                            });
                            setState(() {
                              _joinRequestStatus[flatmateId] = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF29BCA2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _joinRequestStatus[flatmateId] == true
                                ? 'Request Sent'
                                : 'Join Now',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ProductSans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  // Helper method to build info rows in campaign details
  Widget _buildInfoRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF29BCA2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF29BCA2), size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'ProductSans',
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'ProductSans',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build preference chips
  Widget _buildPreferenceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Info text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Browse available flatmate campaign by budget, location, interest etc.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff6B6B6B),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'ProductSans',
                ),
              ),
            ),

            // Main content - Flatmate cards grid
            Expanded(
              child: Obx(
                () =>
                    controller.matches.isEmpty
                        ? _buildNoFlatmatesView()
                        : _buildFlatmatesGridView(),
              ),
            ),
          ],
        ),
        // Add the floating button at the bottom right
        FloatingAddButton(routeName: AppRoutes.ADD_FLATMATE),
      ],
    );
  }

  // Empty state when no flatmates are available
  Widget _buildNoFlatmatesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/home.svg',
            width: 80,
            height: 80,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Flatmates Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'There are no flatmates matching your criteria at the moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: 'ProductSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Grid view of flatmate cards
  Widget _buildFlatmatesGridView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.matches.length,
        itemBuilder: (context, index) {
          final flatmate = controller.matches[index];
          return _buildFlatmateCard(flatmate);
        },
      ),
    );
  }

  // Individual flatmate card - now using the FlatmateCard widget
  Widget _buildFlatmateCard(Map<String, dynamic> flatmate) {
    return FlatmateCard(flatmate: flatmate);
  }
}
