import 'package:flutter/material.dart';
import 'package:ykshocamm/data/tarih_verileri.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../models/onemli_gun_model.dart';
import '../../data/tarih_verileri.dart';

class OnemliGunKarti extends StatelessWidget {
  final OnemliGunModel plan;

  const OnemliGunKarti({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    // plan.tarih zaten DateTime olduğu için direkt extension kullanıyoruz
    final String gunAy = "${plan.tarih.day} ${plan.tarih.ayIsmi}";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.event_note, color: mainPurple),
                gapW10,
                Flexible(
                  child: Text(
                    plan.baslik,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    overflow: TextOverflow.ellipsis, // Yazı çok uzunsa ... yapar
                  ),
                ),
              ],
            ),
          ),
          Text(
            gunAy,
            style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}