import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyMatch extends StatefulWidget {
  const MyMatch({super.key});

  @override
  State<MyMatch> createState() => _MyMatchState();
}

class _MyMatchState extends State<MyMatch> {
  // List of matches (sample data)
  final List<Map<String, dynamic>> _matches = [
    {
      'name': 'John Doe',
      'age': 28,
      'image': 'https://randomuser.me/api/portraits/men/32.jpg',
      'location': 'Lagos',
      'isVerified': true,
    },
    {
      'name': 'Jane Smith',
      'age': 26,
      'image': 'https://randomuser.me/api/portraits/women/44.jpg',
      'location': 'Abuja',
      'isVerified': false,
    },
    {
      'name': 'Mike Johnson',
      'age': 30,
      'image': 'https://randomuser.me/api/portraits/men/67.jpg',
      'location': 'Port Harcourt',
      'isVerified': true,
    },
    {
      'name': 'Sarah Williams',
      'age': 24,
      'image': 'https://randomuser.me/api/portraits/women/32.jpg',
      'location': 'Kano',
      'isVerified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Matches',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProductSans',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final match = _matches[index];
                return _buildMatchCard(match);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                match['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
              ),
            ),
            if (match['isVerified'])
              Positioned(
                bottom: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/icons/verified.png',
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          '${match['name']}, ${match['age']}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'ProductSans',
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              match['location'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.message_outlined, color: Colors.blue),
          onPressed: () {
            // Open chat with this match
          },
        ),
        onTap: () {
          // Navigate to match details
        },
      ),
    );
  }
}
