import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class ProfilIstatistikKarti extends StatelessWidget {
  final String baslik;
  final String deger;

  const ProfilIstatistikKarti({
    super.key,
    required this.baslik,
    required this.deger,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: double.infinity,
            decoration: BoxDecoration(
              // mainPurple -> theme/renkler.dart
              color: mainPurple,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              deger,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}