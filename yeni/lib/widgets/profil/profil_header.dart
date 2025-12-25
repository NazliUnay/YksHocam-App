import 'package:flutter/material.dart';
import '../../theme/renkler.dart';
class ProfilHeader extends StatelessWidget {
  final VoidCallback onCikisYap;

  const ProfilHeader({super.key, required this.onCikisYap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Profil",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
        ),
        TextButton.icon(
          onPressed: onCikisYap,
          icon: const Icon(Icons.logout, color: mainPurple, size: 20),
          label: const Text(
            "Çıkış Yap",
            style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}