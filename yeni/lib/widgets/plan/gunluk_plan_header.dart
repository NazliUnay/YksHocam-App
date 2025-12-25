import 'package:flutter/material.dart';
import 'package:ykshocamm/data/tarih_verileri.dart';

class GunlukPlanHeader extends StatelessWidget {
  final DateTime tarih;

  const GunlukPlanHeader({super.key, required this.tarih});

  @override
  Widget build(BuildContext context) {
    final String tarihBaslik = "${tarih.day} ${tarih.ayIsmi}";

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            tarihBaslik,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: "Serif",
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}