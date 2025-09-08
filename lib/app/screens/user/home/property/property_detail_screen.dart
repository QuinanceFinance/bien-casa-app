import 'package:bien_casa/app/data/property_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'detail_widgets/property_header_image.dart';
import 'detail_widgets/property_title_section.dart';
import 'detail_widgets/property_specifications_row.dart';
import 'detail_widgets/property_description_section.dart';
import 'detail_widgets/area_ranking_widget.dart';
import 'detail_widgets/agent_info_card.dart';
import 'detail_widgets/property_price.dart';

class PropertyDetailScreen extends StatelessWidget {
  PropertyDetailScreen({super.key})
    : property =
          Get.arguments != null
              ? Get.arguments as Map<String, dynamic>
              : PropertyData.defaultProperty;

  final Map<String, dynamic> property;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Important for pull-to-refresh
        slivers: [
          // Add pull-to-refresh functionality
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              // Reload property data
              print('Refreshing property details');
              // Here you would typically fetch fresh data from your controller
              // For now, we'll just simulate a delay
              await Future.delayed(const Duration(seconds: 1));
            },
          ),

          // Property Header Image
          PropertyHeaderImage(property: property),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 26,
                right: 26,
                bottom: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Title Section
                  PropertyTitleSection(property: property),

                  const SizedBox(height: 20),

                  // Property Specifications Row
                  PropertySpecificationsRow(
                    features: property['features'] ?? [],
                  ),

                  const SizedBox(height: 20),

                  // Property Description Section
                  PropertyDescriptionSection(
                    description: property['description'] ?? '',
                    features: property['features'] ?? [],
                    landmarks: property['landmarks'] ?? [],
                  ),

                  const SizedBox(height: 24),

                  // Area Ranking
                  AreaRankingWidget(rating: property['rating'] ?? 3.5),

                  const SizedBox(height: 24),

                  // Agent Information
                  AgentInfoCard(sellerProfile: property['sellerProfile']),

                  const SizedBox(height: 30),

                  // Property Price
                  PropertyPrice(property: property),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
