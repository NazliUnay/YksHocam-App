import 'package:flutter/material.dart';
import '../../theme/stiller.dart'; // homeCardDecoration ve gapH10 buradan geliyor
import '../../theme/renkler.dart';

class AliskanlikKarti extends StatelessWidget {
  final String isim;
  final IconData icon;
  final VoidCallback onTap;

  const AliskanlikKarti({
    super.key,
    required this.isim,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: homeCardDecoration().copyWith(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color:mainPurple,
            ),
            gapH10, // theme/stiller.dart
            Text(
              isim,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}