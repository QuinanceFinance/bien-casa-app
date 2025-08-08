import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 76),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 1,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'ProductSans',
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              color: currentIndex == 0 ? Colors.black : Colors.grey,
              height: 25,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/flatmate.svg',
              color: currentIndex == 1 ? Colors.black : Colors.grey,
              height: 25,
            ),
            label: 'Flatmate',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/marketplace.svg',
              color: currentIndex == 2 ? Colors.black : Colors.grey,
              height: 25,
            ),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/wallet.svg',
              color: currentIndex == 3 ? Colors.black : Colors.grey,
              height: 25,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile icon.svg',
              color: currentIndex == 4 ? Colors.black : Colors.grey,
              height: 25,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
