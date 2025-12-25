import 'package:flutter/material.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';

class KonuIlerlemeKarti extends StatelessWidget {
  final double oran; // 0.0 ile 1.0 arası

  const KonuIlerlemeKarti({super.key, required this.oran});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: mainPurple,
          borderRadius: BorderRadius.circular(20),
          boxShadow: customShadow,
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 100),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "%${(oran * 100).toInt()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Tamamlandı",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.emoji_events, color: Colors.amber, size: 100),
          ],
        ),
      ),
    );
  }
}