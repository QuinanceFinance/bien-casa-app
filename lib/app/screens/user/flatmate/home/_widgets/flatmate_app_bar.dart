import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlatmateAppBar extends StatelessWidget {
  const FlatmateAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 27),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu icon
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icons/filter icon.svg',
                  width: 23,
                  height: 23,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),

              SizedBox(width: 20),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icons/swipe.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
            ],
          ),

          // Action icons
          Row(
            children: [
              // Notification icon
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(
                    'assets/icons/search icon.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              // Message icon
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(
                    'assets/icons/message.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              // Profile icon
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(
                    'assets/icons/notification.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
