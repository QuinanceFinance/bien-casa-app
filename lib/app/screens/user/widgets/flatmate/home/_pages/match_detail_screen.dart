import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:swipe_cards/swipe_cards.dart';

// Import the custom swipeable match card
import '../_widgets/swipeable_match_card.dart';

// Import the newly created widgets
import 'my_match.dart';
import 'my_flatmate.dart';
import '../../../../../../controllers/flatmate_controller.dart';

class MatchDetailScreen extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const MatchDetailScreen({super.key, required this.initialData});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final FlatmateController controller = Get.find<FlatmateController>();
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  late MatchEngine _matchEngine;
  int _selectedTabIndex = 0; // 0 for Home, 1 for My Matches, 2 for My Flatmate

  @override
  void initState() {
    super.initState();
    _loadSwipeItems();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  void _loadSwipeItems() {
    for (var i = 0; i < controller.recommendedFlatmates.length; i++) {
      final item = controller.recommendedFlatmates[i];
      _swipeItems.add(
        SwipeItem(
          content: item,
          likeAction: () {
            // Handle like action
            Get.snackbar('Liked', 'You liked ${item['name']}');
          },
          nopeAction: () {
            // Handle dislike action
            Get.snackbar('Passed', 'You passed on ${item['name']}');
          },
          superlikeAction: () {
            // Handle super like action
            Get.snackbar('Super Liked!', 'You super liked ${item['name']}');
          },
        ),
      );
    }
  }

  // Function to handle moving to the next card after a swipe action
  void _nextCard() {
    controller.nextCard();
  }

  // Build a background card with specified offset and rotation
  Widget _buildBackgroundCard(int offset, double rotationDegrees) {
    final cardIndex = controller.currentIndex.value + offset;
    if (cardIndex >= controller.recommendedFlatmates.length)
      return const SizedBox.shrink();

    final cardData = controller.recommendedFlatmates[cardIndex];
    final scale =
        1.0 - (offset * 0.05); // Decrease scale for cards further back

    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle:
            rotationDegrees *
            (3.14159265359 / 180), // Convert degrees to radians
        child: IgnorePointer(
          child: Opacity(
            opacity:
                0.9 - (offset * 0.2), // Decrease opacity for cards further back
            child: SwipeableMatchCard(
              data: cardData,
              onSwipeLeft: () {}, // No-op for background cards
              onSwipeRight: () {}, // No-op for background cards
              isBackground: true, // This will be used in the SwipeableMatchCard
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom App Bar
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            color: Colors.white,
            child: Column(
              children: [
                // Top Bar with back button and icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // iOS-style back button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),

                    // Right side icons
                    Row(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/message.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/notification.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),

                // Navigation Tabs
                const SizedBox(height: 12),
                _buildNavigationTabs(),
              ],
            ),
          ),

          // Main Content
          Expanded(child: _buildSelectedTabContent()),
        ],
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTabIndex) {
      case 0: // Home tab
        return Column(
          children: [
            // Card takes most of the space
            Expanded(
              child: Center(
                child:
                    controller.recommendedFlatmates.isEmpty
                        ? const Text(
                          'No matches available',
                          style: TextStyle(fontSize: 18),
                        )
                        : Obx(() => Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background stacked cards
                            if (controller.currentIndex.value <
                                controller.recommendedFlatmates.length - 2)
                              _buildBackgroundCard(2, -4.82),
                            if (controller.currentIndex.value <
                                controller.recommendedFlatmates.length - 1)
                              _buildBackgroundCard(1, 3.89),

                            // Front card (swipeable)
                            SwipeableMatchCard(
                              key: ValueKey('card-${controller.currentIndex.value}'), // Add key to force rebuilding
                              data:
                                  controller.recommendedFlatmates[controller
                                      .currentIndex
                                      .value],
                              onSwipeLeft: () {
                                // Handle reject action
                                HapticFeedback.mediumImpact();
                                Get.snackbar(
                                  'Passed',
                                  'You passed on ${controller.recommendedFlatmates[controller.currentIndex.value]["name"]}',
                                  snackPosition: SnackPosition.TOP,
                                );
                                _nextCard();
                              },
                              onSwipeRight: () {
                                // Handle accept action
                                HapticFeedback.mediumImpact();
                                Get.snackbar(
                                  'Liked',
                                  'You liked ${controller.recommendedFlatmates[controller.currentIndex.value]["name"]}',
                                  snackPosition: SnackPosition.TOP,
                                );
                                _nextCard();
                              },
                            ),
                          ],
                        )),
              ),
            ),

            // Bottom Action Buttons
            Padding(
              padding: const EdgeInsets.only(
                bottom: 24.0,
                left: 40.0,
                right: 40.0,
              ),
              child: _buildActionButtons(),
            ),
          ],
        );
      case 1: // My Matches tab
        return const MyMatch();
      case 2: // My Flatmate tab
        return const MyFlatMate();
      default:
        return const Center(child: Text('Unknown tab'));
    }
  }

  Widget _buildNavigationTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          // Home icon (no text)
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 0; // Switch to Home tab
              });
            },
            child: SvgPicture.asset(
              'assets/icons/home.svg',
              width: 24,
              height: 24,
              color:
                  _selectedTabIndex == 0
                      ? Colors.black
                      : const Color(0xFFBDBDBD),
            ),
          ),

          // Spacer to push remaining items to center
          const Spacer(flex: 1),

          // My Matches (text only)
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 1; // Switch to My Matches tab
              });
            },
            child: Text(
              'My Matches',
              style: TextStyle(
                fontFamily: 'ProductSans',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color:
                    _selectedTabIndex == 1
                        ? Colors.black
                        : const Color(0xFFBDBDBD),
                fontSize: 18,
                letterSpacing: 0,
              ),
            ),
          ),

          // Space between text items
          const SizedBox(width: 32),

          // My Flatmate (text only)
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 2; // Switch to My Flatmate tab
              });
            },
            child: Text(
              'My Flatmate',
              style: TextStyle(
                fontFamily: 'ProductSans',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color:
                    _selectedTabIndex == 2
                        ? Colors.black
                        : const Color(0xFFBDBDBD),
                fontSize: 18,
                letterSpacing: 0,
              ),
            ),
          ),

          // Spacer to maintain balance
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'ProductSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dislike Button
            _buildActionButton(
              icon: 'assets/icons/red_cancel.svg',
              size: 35,
              onPressed: controller.currentIndex.value < controller.recommendedFlatmates.length ? () {
                // Handle reject action - same as swipe left
                HapticFeedback.mediumImpact();
                Get.snackbar(
                  'Passed',
                  'You passed on ${controller.recommendedFlatmates[controller.currentIndex.value]['name']}',
                  snackPosition: SnackPosition.TOP,
                );
                _nextCard();
              } : null,
            ),

            // Like Button
            _buildActionButton(
              icon: 'assets/icons/green_heart.svg',
              size: 32,
              onPressed: controller.currentIndex.value < controller.recommendedFlatmates.length ? () {
                // Handle accept action - same as swipe right
                HapticFeedback.mediumImpact();
                Get.snackbar(
                  'Liked',
                  'You liked ${controller.recommendedFlatmates[controller.currentIndex.value]['name']}',
                  snackPosition: SnackPosition.TOP,
                );
                _nextCard();
              } : null,
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    ));
  }

  Widget _buildActionButton({
    required String icon,
    required double size,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1.0, // Dim the button when disabled
        child: Center(child: SvgPicture.asset(icon, width: size, height: size)),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
