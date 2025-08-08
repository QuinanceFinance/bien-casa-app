import 'package:bien_casa/app/data/property_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../heart_icon.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> property;

  PropertyDetailScreen({super.key})
    : property =
          Get.arguments != null
              ? Get.arguments as Map<String, dynamic>
              : PropertyData.defaultProperty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Property image with back button and heart icon
          PropertyHeaderImage(property: property),

          // Property details
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
                  // Property name and rating
                  PropertyTitleSection(property: property),

                  const SizedBox(height: 20),

                  // Property specs
                  PropertySpecificationsRow(
                    features: property['features'] ?? [],
                  ),

                  const SizedBox(height: 20),

                  // Description with Features and Landmarks
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

// Individual widgets for Property Detail Screen
class PropertyHeaderImage extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyHeaderImage({super.key, required this.property});

  @override
  State<PropertyHeaderImage> createState() => _PropertyHeaderImageState();
}

// This class implementation was removed as it was a duplicate

class FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              "${_currentPage + 1}/${widget.images.length}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child:
                  widget.images[index].startsWith('http')
                      ? Image.network(
                        widget.images[index],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.black,
                            child: const Center(
                              child: Text(
                                'Image not available',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      )
                      : Image.asset(widget.images[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}

class _PropertyHeaderImageState extends State<PropertyHeaderImage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    // Initialize images list
    if (widget.property['images'] != null &&
        widget.property['images'] is List &&
        (widget.property['images'] as List).isNotEmpty) {
      _images = List<String>.from(widget.property['images']);
    } else {
      // Fallback to placeholder if no images are provided
      _images = ['assets/image/house.png'];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showFullScreenGallery(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder:
            (context) =>
                FullScreenGallery(images: _images, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      floating: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Property image carousel
            PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenGallery(context, index),
                  child:
                      _images[index].startsWith('http')
                          ? Image.network(
                            _images[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                'Error loading network image: ${_images[index]}',
                              );
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('Image not found'),
                                ),
                              );
                            },
                          )
                          : Image.asset(
                            _images[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                'Error loading asset image: ${_images[index]}',
                              );
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('Image not found'),
                                ),
                              );
                            },
                          ),
                );
              },
            ),
            // Gradient overlay for better visibility of icons
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                ),
              ),
            ),
            // Progress indicator
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _images.length,
                  (index) => Container(
                    width: 67,
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color:
                          _currentPage == index
                              ? Colors.white
                              : Color(0xffBDBDBD),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          iconSize: 12,
          onPressed: () => Get.back(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 20.0),
          child: HeartIcon(isWhite: false),
        ),
      ],
    );
  }
}

class PropertyTitleSection extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyTitleSection({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final double rating = property['rating'] ?? 3.5;
    final int reviews = property['reviews'] ?? 1050;
    final Map<String, dynamic> mapCoordinates =
        property['mapCoordinates'] ?? {'latitude': 0.0, 'longitude': 0.0};

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property['name'] ?? 'Blue Ocean Estate',
                style: const TextStyle(
                  fontFamily: 'ProductSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.32,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xff6B6B6B),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      property['address'] ??
                          '101 Jesse Jackson Street, Abuja 198302',
                      style: const TextStyle(
                        fontFamily: 'ProductSans-Light',
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        fontSize: 13,
                        leadingDistribution:
                            TextLeadingDistribution.proportional,
                        letterSpacing: 0,
                        color: Color(0xff6B6B6B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xffFBA01C),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: TextStyle(
                      fontFamily: 'ProductSans-Light',
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                      color: const Color(0xff6B6B6B),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '| $reviews reviews',
                    style: TextStyle(
                      fontFamily: 'ProductSans-Light',
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                      color: const Color(0xff6B6B6B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Open map with coordinates
            final latitude = mapCoordinates['latitude'];
            final longitude = mapCoordinates['longitude'];
            Get.snackbar(
              'Map Location',
              'Opening map at coordinates: $latitude, $longitude',
              snackPosition: SnackPosition.BOTTOM,
            );
            // Here you would typically launch a map with these coordinates
          },
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 4,
                  color: Color(0x26000000),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icons/map.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PropertySpecificationsRow extends StatelessWidget {
  final List<dynamic> features;

  const PropertySpecificationsRow({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < features.length; i++) ...[
            _buildSvgSpecItem(
              features[i]['icon'] ?? 'assets/icons/sqm.svg',
              features[i]['name'] ?? '',
              '',
            ),
            if (i < features.length - 1) const SizedBox(width: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildSvgSpecItem(String svgPath, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'ProductSans-Light',
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'ProductSans-Light',
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class PropertyDescriptionSection extends StatefulWidget {
  final String description;
  final List<dynamic> features;
  final List<dynamic> landmarks;

  const PropertyDescriptionSection({
    super.key,
    required this.description,
    required this.features,
    required this.landmarks,
  });

  @override
  State<PropertyDescriptionSection> createState() =>
      _PropertyDescriptionSectionState();
}

class _PropertyDescriptionSectionState
    extends State<PropertyDescriptionSection> {
  void _showDetailBottomSheet() {
    final Map<String, dynamic> property = Get.arguments ?? {};

    Get.bottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Set the bottom sheet to take up 85% of screen height
      FractionallySizedBox(
        heightFactor: 0.85,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Center drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Property Title Section
                PropertyTitleSection(property: property),

                const SizedBox(height: 20),

                // Property Specifications Row
                PropertySpecificationsRow(features: property['features'] ?? []),

                const SizedBox(height: 20),

                // Description with Features and Landmarks always visible
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontFamily: 'ProductSans-Light',
                        fontSize: 14,
                        color: Color(0xff6B6B6B),
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.32,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Features - Always visible in bottom sheet
                    const Text(
                      'Features',
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '• ${feature['name']}',
                          style: const TextStyle(
                            fontFamily: 'ProductSans',
                            fontSize: 14,
                            color: Color(0xff6B6B6B),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Landmarks - Always visible in bottom sheet
                    const Text(
                      'Landmarks',
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.landmarks
                        .map(
                          (landmark) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '• $landmark',
                              style: const TextStyle(
                                fontFamily: 'ProductSans',
                                fontSize: 14,
                                color: Color(0xff6B6B6B),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        )
                        ,
                  ],
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

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: widget.description,
                style: const TextStyle(
                  fontFamily: 'ProductSans-Light',
                  fontSize: 14,
                  color: Color(0xff6B6B6B),
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.32,
                  height: 1.4,
                ),
              ),
              TextSpan(
                text: ' read more',
                style: const TextStyle(
                  fontFamily: 'ProductSans',
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                  height: 1.4,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        _showDetailBottomSheet();
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AreaRankingWidget extends StatelessWidget {
  final double rating;

  const AreaRankingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Area Ranking',
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side with rating and stars
            Column(
              children: [
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontFamily: 'ProductSans',
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        i < rating.floor()
                            ? Icons.star
                            : Icons.star_border_rounded,
                        color: const Color(0xFFFBA01C),
                        size: 16,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Right side with ranking bars
            Expanded(
              child: Column(
                children: [
                  _buildRankingBar('Security', 0.9),
                  _buildRankingBar('Market', 0.7),
                  _buildRankingBar('School', 0.8),
                  _buildRankingBar('Police station', 0.6),
                  _buildRankingBar('Gas station', 0.75),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRankingBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'ProductSans',
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xff6B6B6B),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBA01C),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgentInfoCard extends StatelessWidget {
  final Map<String, dynamic>? sellerProfile;

  const AgentInfoCard({super.key, required this.sellerProfile});

  @override
  Widget build(BuildContext context) {
    final String name = sellerProfile?['name'] ?? '';
    final String level = sellerProfile?['level'] ?? '';
    final bool isVerified = sellerProfile?['isVerified'] ?? false;
    final String avatar =
        sellerProfile?['avatar'] ?? 'assets/image/agent_avatar.png';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seller Information',
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            avatar.startsWith('http')
                ? CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade300,
                  child: ClipOval(
                    child: Image.network(
                      avatar,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 30);
                      },
                    ),
                  ),
                )
                : CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(avatar),
                  backgroundColor: Colors.grey.shade300,
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'ProductSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Text(
                        level,
                        style: const TextStyle(
                          fontFamily: 'ProductSans',
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),

                      if (isVerified)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Image.asset(
                            'assets/icons/verified.png',
                            width: 16,
                            height: 16,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SvgPicture.asset('assets/icons/message.svg', width: 20, height: 20),
          ],
        ),
      ],
    );
  }
}

class PropertyPrice extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyPrice({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      property['price'] ?? '₦0',
                      style: const TextStyle(
                        fontFamily: 'ProductSans',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  property['discount'] ?? '15% off',
                  style: const TextStyle(
                    fontFamily: 'ProductSans',
                    fontSize: 16,
                    color: Color(0xffDC3545),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            // Make an offer button
            Stack(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      'Make an Offer',
                      'Opening offer form',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text(
                    'Make an offer',
                    style: TextStyle(
                      fontFamily: 'ProductSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                Positioned(
                  right: double.minPositive,
                  bottom: 35,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Text(
                      'pro',
                      style: TextStyle(
                        color: Color(0xffFBA01C),
                        fontFamily: 'ProductSans',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        // Schedule inspection button
        SizedBox(
          height: 70,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff020202),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              Get.snackbar(
                'Schedule Inspection',
                'Opening inspection booking',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Schedule inspection',
              style: TextStyle(
                fontFamily: 'ProductSans',
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
