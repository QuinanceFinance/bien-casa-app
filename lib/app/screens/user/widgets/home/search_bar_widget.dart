import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBarWidget extends StatelessWidget {
  final Function()? onTap;
  
  const SearchBarWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 46,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/search icon.svg',
              color: Colors.black,
            ),
            const SizedBox(width: 10),
            Text(
              'Search Bien Casa...',
              style: TextStyle(
                color: Color(0xffBDBDBD),
                fontSize: 16,
                fontFamily: 'ProductSans',
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/icons/filter icon.svg',
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
