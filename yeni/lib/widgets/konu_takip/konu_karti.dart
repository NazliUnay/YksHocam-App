import 'package:flutter/material.dart';
import '../../models/konu_model.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart'; // homeCardDecoration

class KonuKarti extends StatelessWidget {
  final KonuModel konu;
  final Function(bool?) onDurumDegisti;

  const KonuKarti({
    super.key,
    required this.konu,
    required this.onDurumDegisti,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Kutu Dekorasyonu: Tamamlandıysa mor, değilse standart beyaz/dekorasyon
      decoration: homeCardDecoration().copyWith(
        color: konu.tamamlandiMi ? mainPurple : Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        leading: Checkbox(
          value: konu.tamamlandiMi,
          // Kutu morken checkbox ve tik rengini beyaz/mor kontrastına göre ayarlar
          activeColor: konu.tamamlandiMi ? Colors.white : mainPurple,
          checkColor: konu.tamamlandiMi ? mainPurple : Colors.white,
          shape: const CircleBorder(),
          side: BorderSide(
            color: konu.tamamlandiMi ? Colors.white : Colors.grey.shade400,
            width: 1.5,
          ),
          onChanged: onDurumDegisti,
        ),
        title: Text(
          konu.ad,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // Yazı Rengi: Kutu morken beyaz, değilse siyah (silik değil)
            color: konu.tamamlandiMi ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}