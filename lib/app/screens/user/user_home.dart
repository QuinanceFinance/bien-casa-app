import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../controllers/user_home_controller.dart';
import 'widgets/home/featured_property_card.dart';
import 'widgets/home/horizontal_property_list.dart';
import 'widgets/home/search_bar_widget.dart';
import 'widgets/home/section_header.dart';
import 'widgets/home/location_property_list.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // Get the UserHomeController using GetX
  final UserHomeController _controller = Get.find<UserHomeController>();

  int _currentIndex = 0;

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/message.svg',
              color: Colors.black,
            ),
            onPressed: () {
              // Could implement message functionality here
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/notification.svg',
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Search Bar
              SearchBarWidget(onTap: () => _controller.navigateToSearch()),
              const SizedBox(height: 16),

              // Featured Property Section Header
              SectionHeader(
                title: 'Featured',
                viewAllText: 'View all',
                onViewAllTap: () => _controller.navigateToFeaturedProperties(),
              ),

              // Featured Properties Carousel with Progress Indicators
              Container(
                height: 320, // Adjust height as needed
                margin: const EdgeInsets.only(top: 16),
                child: Stack(
                  children: [
                    // Property Carousel
                    PageView.builder(
                      controller: _controller.featuredPageController,
                      itemCount: _controller.featuredProperties.length,
                      itemBuilder: (context, index) {
                        final item = _controller.featuredProperties[index];
                        return Container(
                          width: MediaQuery.of(context).size.width - 40,
                          margin: const EdgeInsets.only(right: 12),
                          child: FeaturedPropertyCard(
                            imageUrl:
                                item['images'] != null &&
                                        (item['images'] as List).isNotEmpty
                                    ? item['images'][0]
                                    : '',
                            name: item['name'] ?? '',
                            address: item['address'] ?? '',
                            price: item['price'] ?? '',
                            size: item['size'] ?? '',
                            type: item['type'] ?? '',
                            currentIndex:
                                _controller.currentFeaturedIndex.value,
                            totalItems: _controller.featuredProperties.length,
                            onTap:
                                () =>
                                    _controller.navigateToPropertyDetail(item),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Recently added houses
              SectionHeader(
                title: 'Recently added houses for sale',
                viewAllText: 'View all',
                onViewAllTap:
                    () => _controller.navigateToRecentlyAddedProperties(),
              ),

              Container(
                margin: const EdgeInsets.only(top: 4),
                child: HorizontalPropertyList(
                  properties: _controller.recentlyAddedProperties,
                  onItemTap:
                      (index) => _controller.navigateToPropertyDetail(
                        _controller.recentlyAddedProperties[index],
                      ),
                ),
              ),

              // Most searched houses by location
              Obx(() {
                final location = _controller.selectedLocation.value;
                return LocationPropertyList(
                  locationName: location,
                  properties: _controller.locationProperties[location] ?? [],
                  onItemTap:
                      (index) => _controller.navigateToPropertyDetail(
                        _controller.locationProperties[location]![index],
                      ),
                  onViewAllTap:
                      () => _controller.navigateToLocationProperties(location),
                );
              }),

              // Add some bottom padding
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
