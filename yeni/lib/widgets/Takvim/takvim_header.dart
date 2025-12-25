import 'package:flutter/material.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../data/tarih_verileri.dart';

class TakvimHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const TakvimHeader({
    super.key,
    required this.focusedDay,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Geri butonu
        const BackButton(color: mainPurple),

        Row(
          children: [
            Text(
              "${focusedDay.ayIsmi} ${focusedDay.year}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Serif",
              ),
            ),
            gapW10,
            Column(
              children: [
                GestureDetector(
                  onTap: onPreviousMonth,
                  child: const Icon(Icons.keyboard_arrow_up, size: 28, color: Colors.black54),
                ),
                GestureDetector(
                  onTap: onNextMonth,
                  child: const Icon(Icons.keyboard_arrow_down, size: 28, color: Colors.black54),
                ),
              ],
            )
          ],
        ),
        // Simetriyi sağlamak için görünmez boşluk
        const SizedBox(width: 48),
      ],
    );
  }
}