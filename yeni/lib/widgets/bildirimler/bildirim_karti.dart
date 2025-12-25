import 'package:flutter/material.dart';
import '../../models/bildirim_model.dart';
import '../../theme/renkler.dart';  // mainPurple için
import '../../theme/stiller.dart';  // customShadow ve gapW10 için

class BildirimKarti extends StatelessWidget {
  final BildirimModel bildirim;
  final VoidCallback onSil;

  const BildirimKarti({
    super.key,
    required this.bildirim,
    required this.onSil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        // theme/stiller.dart'tan gelen gölge
        boxShadow: customShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: mainPurple, size: 28),
          gapW10, // theme/stiller.dart
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bildirim.baslik,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  bildirim.zaman,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
          // Silme Butonu
          GestureDetector(
            onTap: onSil,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: mainPurple.withOpacity(0.5)),
              ),
              child: const Icon(Icons.close, color: mainPurple, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}