import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFlatMate extends StatefulWidget {
  const MyFlatMate({super.key});

  @override
  State<MyFlatMate> createState() => _MyFlatMateState();
}

class _MyFlatMateState extends State<MyFlatMate> {
  // Sample flatmate data
  final Map<String, dynamic> _flatmate = {
    'name': 'Alex Johnson',
    'age': 27,
    'image': 'https://randomuser.me/api/portraits/men/45.jpg',
    'occupation': 'Software Engineer',
    'location': 'Lagos',
    'moveInDate': '15 September 2025',
    'rentAmount': '₦350,000',
    'about': 'I\'m a software engineer who enjoys quiet evenings and occasionally going out on weekends. I\'m clean, organized, and respectful of shared spaces.',
    'interests': ['Reading', 'Coding', 'Hiking', 'Movies'],
    'isVerified': true,
    'contactInfo': {
      'phone': '+234 812 345 6789',
      'email': 'alex.j@example.com',
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: _flatmate.isEmpty
          ? _buildNoFlatmateView()
          : _buildFlatmateProfileView(),
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
            color: Colors.grey,
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
              backgroundColor: const Color(0xFF007AFF),
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

  Widget _buildFlatmateProfileView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_flatmate['image']),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle error loading image
                      },
                    ),
                    if (_flatmate['isVerified'])
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/verified.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${_flatmate['name']}, ${_flatmate['age']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ProductSans',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/work.svg',
                      width: 16,
                      height: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _flatmate['occupation'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'ProductSans',
                      ),
                    ),
                    const SizedBox(width: 16),
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      width: 16,
                      height: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _flatmate['location'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'ProductSans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Move-in Details
          _buildInfoSection('Move-in Date', _flatmate['moveInDate']),
          _buildInfoSection('Monthly Rent', _flatmate['rentAmount']),
          
          const SizedBox(height: 24),
          
          // About Section
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
            _flatmate['about'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
              fontFamily: 'ProductSans',
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Interests
          const Text(
            'Interests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_flatmate['interests'] as List).map<Widget>((interest) {
              return Chip(
                label: Text(
                  interest,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: 'ProductSans',
                  ),
                ),
                backgroundColor: Colors.grey.shade200,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Contact Information
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 16),
          _buildContactInfoRow(Icons.phone, _flatmate['contactInfo']['phone']),
          const SizedBox(height: 8),
          _buildContactInfoRow(Icons.email, _flatmate['contactInfo']['email']),
          
          const SizedBox(height: 40),
          
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.message,
                label: 'Message',
                color: Colors.blue,
                onTap: () {
                  // Open chat with flatmate
                },
              ),
              _buildActionButton(
                icon: Icons.video_call,
                label: 'Video Call',
                color: Colors.green,
                onTap: () {
                  // Start video call
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontFamily: 'ProductSans',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'ProductSans',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'ProductSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
