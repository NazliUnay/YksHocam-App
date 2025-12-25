import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class ProfilIsimSatiri extends StatelessWidget {
  final String adSoyad;
  final VoidCallback onTap;

  const ProfilIsimSatiri({
    super.key,
    required this.adSoyad,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          adSoyad.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: mainPurple,
            letterSpacing: 1.2,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: mainPurple, size: 30),
          onPressed: onTap,
        ),
      ],
    );
  }
}