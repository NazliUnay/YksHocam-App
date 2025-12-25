import 'package:flutter/material.dart';
import '../../theme/renkler.dart'; // mainPurple rengi buradan geliyor
import '../../theme/stiller.dart'; // gapH30 buradan geliyor

class BildirimBosDurum extends StatelessWidget {
  const BildirimBosDurum({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Center(
          child: Column(
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: mainPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications, color: Colors.white, size: 100),
              ),
              gapH30, // theme/stiller.dart
              const Text(
                "Henüz bir bildiriminiz yok",
                style: TextStyle(
                  color: mainPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}