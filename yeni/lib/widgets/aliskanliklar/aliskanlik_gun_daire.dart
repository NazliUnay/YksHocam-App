import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class AliskanlikGunDaire extends StatelessWidget {
  final int gun;
  final bool tamamlandiMi;
  final VoidCallback onTap;

  const AliskanlikGunDaire({
    super.key,
    required this.gun,
    required this.tamamlandiMi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Doluysa mor, boşsa sadece çerçeve
          color: tamamlandiMi ? mainPurple : Colors.transparent,
          border: Border.all(color: mainPurple, width: 2),
        ),
        child: Center(
          child: Text(
            "$gun",
            style: TextStyle(
              color: tamamlandiMi ? Colors.white : mainPurple,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}