import 'package:flutter/material.dart';
import '../../../models/not_model.dart';
import '../../../theme/renkler.dart';  // mainPurple için
import '../../../theme/stiller.dart';  // homeCardDecoration, gapH10, gapH20 için

class NotKarti extends StatelessWidget {
  final NotModel not;
  final bool secimModu;
  final Function(NotModel) onSec;
  final Function(NotModel) onSil;

  const NotKarti({
    super.key,
    required this.not,
    required this.secimModu,
    required this.onSec,
    required this.onSil,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onSec(not), // Uzun basınca seçim modu
      onTap: secimModu ? () => onSec(not) : null, // Seçim modundaysa tıkla-seç
      child: Container(
        padding: const EdgeInsets.all(16),
        // theme/stiller.dart'tan gelen dekorasyon
        decoration: homeCardDecoration().copyWith(
          color: not.seciliMi ? mainPurple.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: not.seciliMi ? mainPurple : Colors.black, // Seçiliyse mor çerçeve
            width: not.seciliMi ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---  SEÇİM İKONU (Sadece Seçim Modunda) ---
            if (secimModu) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    not.seciliMi ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: mainPurple,
                  ),
                ],
              ),
              gapH10,
            ],

            // ---  NOT İÇERİĞİ ---
            Text(
              not.icerik,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),

            gapH20,

            // --- ALT KISIM (Etiket ve Silme Butonu) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ders Etiketi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: mainPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    not.ders,
                    style: const TextStyle(
                      color: mainPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                // SİLME BUTONU (Seçim modunda değilsek görünür)
                if (!secimModu)
                  InkWell(
                    onTap: () => onSil(not),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.delete_outline, size: 24, color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}