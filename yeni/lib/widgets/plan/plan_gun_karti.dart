import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';  // customShadow için

class PlanGunKarti extends StatelessWidget {
  final DateTime tarih;
  final VoidCallback onTap;
  final bool isPastOrToday;

  const PlanGunKarti({
    super.key,
    required this.tarih,
    required this.onTap,
    this.isPastOrToday = false, // Varsayılan olarak false
  });

  @override
  Widget build(BuildContext context) {
    // Türkçe Tarih Formatlaması
    String gunAdi = DateFormat('EEEE', 'tr_TR').format(tarih).toUpperCase();
    String tarihYazi = DateFormat('d MMMM y', 'tr_TR').format(tarih).toUpperCase();

    // Renk Kararı: Artık sadece bugün değil, dışarıdan gelen isPastOrToday bilgisine bakıyoruz
    bool mordaKalsin = isPastOrToday;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: mordaKalsin ? mainPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: mordaKalsin ? null : Border.all(color: Colors.grey.shade300, width: 1.5),

          boxShadow: mordaKalsin
              ? [
            BoxShadow(
              color: mainPurple.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ]
              : customShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tarih (Örn: 24 ARALIK 2025)
            Text(
              tarihYazi,
              style: TextStyle(
                color: mordaKalsin ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Gün Adı (Örn: ÇARŞAMBA)
            Center(
              child: Text(
                gunAdi,
                style: TextStyle(
                  color: mordaKalsin ? Colors.white : mainPurple,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}