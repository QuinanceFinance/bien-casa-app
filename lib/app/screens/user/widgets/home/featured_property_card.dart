import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeaturedPropertyCard extends StatefulWidget {
  final String imageUrl; // First image from images array
  final String name;
  final String address;
  final String price;
  final String size;
  final String type;
  final Function()? onTap;
  final int currentIndex; // Current index in carousel
  final int totalItems; // Total items in carousel

  const FeaturedPropertyCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.price,
    required this.size,
    required this.type,
    this.onTap,
    this.currentIndex = 0, // Default to first item
    this.totalItems = 4, // Default to 4 items
  });

  @override
  State<FeaturedPropertyCard> createState() => _FeaturedPropertyCardState();
}

class _FeaturedPropertyCardState extends State<FeaturedPropertyCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Set to min to prevent overflow
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            height: 350,
            margin: const EdgeInsets.symmetric(
              vertical: 2,
            ), // Further reduced vertical margin
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Property image
                  Positioned.fill(
                    child:
                        widget.imageUrl.startsWith('http')
                            ? Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                );
                              },
                            )
                            : Image.asset(widget.imageUrl, fit: BoxFit.cover),
                  ),
                  // Dark overlay for text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5), // Dark at the top
                            Colors.transparent.withOpacity(
                              0.1,
                            ), // More transparent in middle
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.2, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Progress bar at top of card with higher z-index
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17.5),
                      height: 3,
                      child: Row(
                        children: List.generate(widget.totalItems, (index) {
                          return Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 3,
                                    color:
                                        index == widget.currentIndex
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                  ),
                                ),
                                if (index < widget.totalItems - 1)
                                  const SizedBox(width: 4),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  // Featured tag
                  Positioned(
                    top: 30,
                    left: 16,
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Product Sans Light',
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        height: 1.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  // No favorite button as per design
                  // Property details
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property specs with pill shape
                        Row(
                          children: [
                            _buildPropertySpec(widget.size),
                            const SizedBox(width: 8),
                            _buildPropertySpec(widget.type),
                            const SizedBox(width: 8),
                            _buildPropertySpec(widget.price, isPrice: true),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Property name
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 21,
                            height: 1,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Property address
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.address,
                                style: const TextStyle(
                                  fontFamily: 'Product Sans Light',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Colors.white,
                                  height: 1,
                                  letterSpacing: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 15),
        // External progress bar
        Container(
          height: 3,
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 130),
          child: Row(
            children: List.generate(widget.totalItems, (index) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        color:
                            index == widget.currentIndex
                                ? Colors.black
                                : Color(0xffEAEAEA),
                      ),
                    ),
                    if (index < widget.totalItems - 1) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertySpec(String text, {bool isPrice = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (isPrice)
            SvgPicture.asset(
              'assets/icons/naira.svg',
              width: 13,
              height: 13,
              color: Colors.white,
            ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              fontSize: 13,
              color: Colors.white,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
