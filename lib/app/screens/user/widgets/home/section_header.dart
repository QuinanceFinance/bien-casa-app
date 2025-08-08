import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? viewAllText;
  final Function()? onViewAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.viewAllText,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'ProductSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (viewAllText != null)
            GestureDetector(
              onTap: onViewAllTap,
              child: Text(
                viewAllText!,
                style: const TextStyle(
                  fontFamily: 'ProductSans',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
