import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeartIcon extends StatefulWidget {
  final bool isWhite;
  final double size;
  final double padding;
  final double iconSize;
  final VoidCallback? onTap;

  const HeartIcon({
    super.key,
    this.isWhite = true,
    this.size = 32.0,
    this.padding = 6.0,
    this.iconSize = 16.0,
    this.onTap,
  });

  @override
  State<HeartIcon> createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
        
        // Show feedback to user
        Get.snackbar(
          'Favorite',
          isFavorite ? 'Added to favorites' : 'Removed from favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
        
        // Call the original onTap if provided
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isWhite 
              ? Colors.white.withOpacity(0.9) 
              : Colors.black.withOpacity(0.6),
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
          color: isFavorite 
              ? Colors.red 
              : (widget.isWhite ? Colors.black : Colors.white),
          size: widget.iconSize,
        ),
      ),
    );
  }
}
