import 'package:flutter/material.dart';
import '../../theme/stiller.dart'; // timerCardDecoration ve gapH20 buradan geliyor

class SayacKarti extends StatelessWidget {
  final DateTime? targetDate;
  final Duration kalanSure;

  const SayacKarti({
    super.key,
    required this.targetDate,
    required this.kalanSure,
  });

  @override
  Widget build(BuildContext context) {
    // Süre Hesaplamaları
    final kalanSaniyeToplami = kalanSure.inSeconds.abs();
    int ay = (kalanSaniyeToplami ~/ (30 * 24 * 3600));
    int gun = (kalanSaniyeToplami ~/ (24 * 3600)) % 30;
    int saat = (kalanSaniyeToplami ~/ 3600) % 24;
    int dakika = (kalanSaniyeToplami ~/ 60) % 60;
    int saniye = kalanSaniyeToplami % 60;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: timerCardDecoration(),
      child: Column(
        children: [
          const Text(
            "Sınava Ne Kadar Kaldı",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          gapH20, // theme/stiller.dart

          // build metodu içinde Row kısmını şu şekilde güncelleyebilirsiniz:
          targetDate == null || kalanSure == Duration.zero
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeItem(ay, "Ay"),
                    _buildTimeItem(gun, "Gün"),
                    _buildTimeItem(saat, "Saat"),
                    _buildTimeItem(dakika, "Dakika"),
                    _buildTimeItem(saniye, "Saniye"),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(int value, String label) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}
