import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'heart_icon.dart';

class PropertyListItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String address;
  final String size;
  final String type;
  final String price;
  final Function()? onTap;

  const PropertyListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.size,
    required this.type,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x26000000),
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Property image with heart icon - LEFT SIDE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                  child:
                      imageUrl.startsWith('http')
                          ? Image.network(
                            imageUrl,
                            width: 136,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 136,
                                height: double.infinity,
                                color: Colors.grey[200],
                                child: Center(
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
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 136,
                                height: double.infinity,
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.error)),
                              );
                            },
                          )
                          : Image.asset(
                            imageUrl,
                            width: 136,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 136,
                                height: double.infinity,
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.error)),
                              );
                            },
                          ),
                ),
                // Heart icon
                Positioned(
                  top: 10,
                  left: 10,
                  child: const HeartIcon(
                    isWhite: false,
                    padding: 6,
                    iconSize: 16,
                  ),
                ),
              ],
            ),

            // Property details - RIGHT SIDE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Location with pin icon
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontFamily: 'ProductSans',
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Area and type
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/sqm.svg',
                          height: 14,
                          width: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$size - $type',
                          style: const TextStyle(
                            fontFamily: 'ProductSans',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price with bolder styling
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: price.split(' ')[0],
                            style: const TextStyle(
                              fontFamily: 'ProductSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' ${price.split(' ').skip(1).join(' ')}', // The 'per unit' text
                            style: const TextStyle(
                              fontFamily: 'ProductSans',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
