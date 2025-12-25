import 'package:flutter/material.dart';
import '../../theme/stiller.dart'; // homeCardDecoration, gapH10

class NotKategoriKarti extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const NotKategoriKarti({
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
        height: 180,
        // theme/stiller.dart dosyasından geliyor
        decoration: homeCardDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Resim Alanı
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: 50, color: Colors.grey.shade300);
                  },
                ),
              ),
            ),

            // Yazı Alanı
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            gapH10,
          ],
        ),
      ),
    );
  }
}