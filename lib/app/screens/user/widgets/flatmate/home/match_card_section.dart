import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../controllers/flatmate_controller.dart';

class MatchCardSection extends StatelessWidget {
  const MatchCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final FlatmateController controller = Get.find<FlatmateController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          MatchCardStack(matches: controller.recommendedFlatmates),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

class MatchCardStack extends StatefulWidget {
  final List<Map<String, dynamic>> matches;

  const MatchCardStack({super.key, required this.matches});

  @override
  State<MatchCardStack> createState() => _MatchCardStackState();
}

class _MatchCardStackState extends State<MatchCardStack>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  final List<GlobalKey<_MatchCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize card keys
    for (int i = 0; i < widget.matches.length; i++) {
      _cardKeys.add(GlobalKey<_MatchCardState>());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSwipe(bool isRight) {
    if (_currentIndex >= widget.matches.length - 1) return;

    // Get the current card's state to trigger its animation
    final currentCardKey = _cardKeys[_currentIndex];
    currentCardKey.currentState?.animateSwipe(isRight);

    // After animation completes, update the index
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(alignment: Alignment.center, children: _buildCardStack()),
    );
  }

  List<Widget> _buildCardStack() {
    List<Widget> cards = [];

    // Build a stack of cards, with only the top 3 visible
    for (int i = widget.matches.length - 1; i >= 0; i--) {
      if (i < _currentIndex) continue; // Skip cards that have been swiped
      if (i > _currentIndex + 2) {
        continue; // Only show next 3 cards for performance
      }

      final isTopCard = i == _currentIndex;
      final distanceFromTop = i - _currentIndex;

      // Calculate scale and opacity based on position in stack
      final scale = 1.0 - (distanceFromTop * 0.08);
      final opacity = 1.0 - (distanceFromTop * 0.2);
      final yOffset = distanceFromTop * 10.0;
      final rotation = isTopCard ? 7.54 : -6.02 * distanceFromTop;

      Widget card = Transform.translate(
        offset: Offset(0, yOffset),
        child: Transform.rotate(
          angle: rotation * (3.14159 / 180), // Convert degrees to radians
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity.clamp(0.4, 1.0),
              child: MatchCard(
                key: _cardKeys[i],
                match: widget.matches[i],
                onSwipeLeft: isTopCard ? () => _handleSwipe(false) : () {},
                onSwipeRight: isTopCard ? () => _handleSwipe(true) : () {},
                isActive: isTopCard,
              ),
            ),
          ),
        ),
      );

      // Add the card to the stack
      if (isTopCard) {
        card = Positioned.fill(child: card);
      } else {
        card = Positioned(
          top: yOffset,
          left: 0,
          right: 0,
          bottom: 0,
          child: card,
        );
      }

      cards.add(card);
    }

    // No more matches
    if (_currentIndex >= widget.matches.length) {
      cards.add(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No more matches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'Product Sans',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      );
    }

    return cards;
  }
}

class MatchCard extends StatefulWidget {
  final Map<String, dynamic> match;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final bool isActive;

  const MatchCard({
    super.key,
    required this.match,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.isActive = true,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void animateSwipe(bool isRight) {
    // Set up the animation
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(isRight ? 1.5 : -1.5, 0),
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: isRight ? 0.3 : -0.3,
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));

    // Run the animation
    _swipeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd:
          widget.isActive
              ? (details) {
                if (details.primaryVelocity! > 0) {
                  // Swiped right
                  widget.onSwipeRight();
                } else if (details.primaryVelocity! < 0) {
                  // Swiped left
                  widget.onSwipeLeft();
                }
              }
              : null,
      child: AnimatedBuilder(
        animation: _swipeController,
        builder: (context, child) {
          return SlideTransition(
            position: _swipeAnimation,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: 217.99999479175176,
                height: 309.99999273850005,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background image
                      Image.network(
                        '${widget.match['image']}?auto=format&fit=crop&w=600&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.grey[300]!, Colors.grey[400]!],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),

                      // Gradient overlay with stronger dark overlay at bottom
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                          ),
                        ),
                      ),

                      // Profile information overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Name and age
                              Text(
                                '${widget.match['name']}, ${widget.match['age']}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontFamily: 'Product Sans',
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Gender, Religion, Occupation
                              Text(
                                '${widget.match['gender'] ?? 'Male'} | ${widget.match['religion'] ?? 'Christian'} | ${widget.match['occupation']}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.white.withOpacity(0.9),
                                  fontFamily: 'Product Sans',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Income range
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/naira.svg',
                                        width: 14,
                                        height: 14,
                                        color: Colors.white.withOpacity(0.95),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${widget.match['income'] ?? '400k - 600k/yr'}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withOpacity(0.95),
                                          fontFamily: 'Product Sans',
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                ],
                              ),

                              // Location
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.match['location'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                      fontFamily: 'Product Sans',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
