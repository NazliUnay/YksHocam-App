import 'package:flutter/material.dart';
import '../../theme/stiller.dart'; // homeCardDecoration, customShadow ve gapH10 buradan geliyor

class AnaSayfaMenuKart extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const AnaSayfaMenuKart({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        // theme/stiller.dart'tan gelen dekorasyon ve gölge
        decoration: homeCardDecoration().copyWith(
          boxShadow: customShadow,
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 70),
            gapH10,
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}