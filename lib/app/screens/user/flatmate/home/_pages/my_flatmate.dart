import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../controllers/flatmate_match_controller.dart';

class MyFlatMate extends StatefulWidget {
  const MyFlatMate({super.key});

  @override
  State<MyFlatMate> createState() => _MyFlatMateState();
}

class _MyFlatMateState extends State<MyFlatMate> {
  // Get controller
  final FlatmateMatchController controller =
      Get.find<FlatmateMatchController>();

  // Sample flatmate data - will be replaced with controller data
  final Map<String, dynamic> _flatmate = {
    'name': 'Alex Johnson',
    'age': 27,
    'image': 'https://randomuser.me/api/portraits/men/45.jpg',
    'occupation': 'Software Engineer',
    'location': 'Lagos',
    'moveInDate': '15 September 2025',
    'rentAmount': '₦350,000',
    'about':
        'I\'m a software engineer who enjoys quiet evenings and occasionally going out on weekends. I\'m clean, organized, and respectful of shared spaces.',
    'interests': ['Reading', 'Coding', 'Hiking', 'Movies'],
    'isVerified': true,
    'contactInfo': {
      'phone': '+234 812 345 6789',
      'email': 'alex.j@example.com',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () =>
            controller.myFlatmates.isEmpty
                ? _buildNoFlatmateView()
                : _buildFlatmateGridView(),
      ),
    );
  }

  Widget _buildNoFlatmateView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/home.svg',
            width: 100,
            height: 100,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Flatmate Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You haven\'t matched with a flatmate yet.\nKeep swiping to find your perfect match!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to swiping screen
              Get.back(); // Go back to main screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF29BCA2),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Start Matching',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'ProductSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build grid view of flatmate cards
  Widget _buildFlatmateGridView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomScrollView(
        slivers: [
          // Flatmate grid
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final flatmate = controller.myFlatmates[index];
              return _buildFlatmateCard(flatmate);
            }, childCount: controller.myFlatmates.length),
          ),

          // Chat with Flatmates button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _buildChatButton(),
            ),
          ),

          // Smart Matches section
          SliverToBoxAdapter(child: _buildSmartMatchesSection()),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  // Build individual flatmate card
  Widget _buildFlatmateCard(Map<String, dynamic> flatmate) {
    return GestureDetector(
      onTap: () => controller.viewMyFlatmateDetails(flatmate),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
              flatmate['image'] ??
                  'https://randomuser.me/api/portraits/men/45.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${flatmate['name'] ?? 'Unknown'}, ${flatmate['age'] ?? '??'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ProductSans',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${flatmate['gender'] ?? 'Unknown'} | ${flatmate['religion'] ?? 'Unknown'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'ProductSans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flatmate['location'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'ProductSans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Chat with Flatmates button
  Widget _buildChatButton() {
    return GestureDetector(
      onTap: () {
        // Handle chat with flatmates
        Get.snackbar(
          'Chat',
          'Opening chat with flatmates',
          snackPosition: SnackPosition.TOP,
        );
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xff29BCA2).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/chat.svg', // Use appropriate icon
              width: 26,
              height: 25,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Text(
              'Chat with Flatmates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'ProductSans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Smart Matches section
  Widget _buildSmartMatchesSection() {
    return Image.asset(
      'assets/icons/smart matches section.png',
      height: 385,
      // fit: BoxFit.contain,
      // width: double.infinity,
    );
  }
}
