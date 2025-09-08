import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../controllers/flatmate_match_controller.dart';

class FlatmateCard extends StatelessWidget {
  final Map<String, dynamic> flatmate;
  
  const FlatmateCard({
    super.key,
    required this.flatmate,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlatmateMatchController>();
    
    return GestureDetector(
      onTap: () => controller.viewMatchDetails(flatmate),
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
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Name and age
                Text(
                  '${flatmate['name']}, ${flatmate['age']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ProductSans',
                  ),
                ),
                const SizedBox(height: 4),

                // Gender, Religion, Occupation
                Row(
                  children: [
                    Text(
                      '${flatmate['gender']} | ${flatmate['religion']} | ${flatmate['occupation']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'ProductSans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Budget info with Naira
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/naira.svg',
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 1.75),
                        Text(
                          flatmate['budget'] ?? '500k - 600k/yr',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'ProductSans',
                          ),
                        ),
                      ],
                    ),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 1.75),
                        Text(
                          flatmate['location'] ?? 'Abuja',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
