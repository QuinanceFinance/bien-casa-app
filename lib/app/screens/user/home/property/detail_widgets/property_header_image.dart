import 'dart:async';
import 'package:bien_casa/app/screens/user/home/heart_icon.dart';
import 'package:bien_casa/app/screens/user/home/gallery_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'full_screen_gallery.dart';

class PropertyHeaderImage extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyHeaderImage({super.key, required this.property});

  @override
  State<PropertyHeaderImage> createState() => _PropertyHeaderImageState();
}

class _PropertyHeaderImageState extends State<PropertyHeaderImage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<String> _images = [];
  Timer? _autoSlideTimer;

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

    // Start auto-slide timer if there are multiple images
    if (_images.length > 1) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    // Auto-slide every 5 seconds
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  void _showFullScreenGallery(BuildContext context, int initialIndex) {
    print('_showFullScreenGallery called with initialIndex: $initialIndex');
    print('Images to show: $_images');
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          print('Building FullScreenGallery route');
          return FullScreenGallery(images: _images, initialIndex: initialIndex);
        },
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
                // Wrap the image in a Stack to handle both tap events and auto-slide
                return Stack(
                  children: [
                    // Image widget
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
                                            loadingProgress.expectedTotalBytes!
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

                    // Transparent overlay for tap detection
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white24,
                          onTap: () {
                            print('Simple onTap detected on image $index');
                            _showFullScreenGallery(context, index);
                          },
                        ),
                      ),
                    ),
                  ],
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
            // Progress indicator dots
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
            // Debug button to test FullScreenGallery
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
        // View gallery icon
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 10.0),
          child: GalleryIcon(
            isWhite: false,
            size: 32.0,
            padding: 6.0,
            iconSize: 16.0,
            images: _images,
            currentIndex: _currentPage,
          ),
        ),
        // Favorite icon
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 20.0),
          child: HeartIcon(isWhite: false),
        ),
      ],
    );
  }
}
