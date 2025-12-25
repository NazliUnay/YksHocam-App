import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class KonuDersMenu extends StatelessWidget {
  final List<String> dersler;
  final String seciliDers;
  final Function(String) onDersSecildi;

  const KonuDersMenu({
    super.key,
    required this.dersler,
    required this.seciliDers,
    required this.onDersSecildi,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: dersler.map((ders) {
          bool isSelected = seciliDers == ders;
          return GestureDetector(
            onTap: () => onDersSecildi(ders),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                border: isSelected
                    ? const Border(bottom: BorderSide(color: mainPurple, width: 3))
                    : null,
              ),
              child: Text(
                ders,
                style: TextStyle(
                  color: isSelected ? mainPurple : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}