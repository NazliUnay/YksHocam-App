import 'package:flutter/material.dart';
import '../../theme/renkler.dart';  // mainPurple için
import '../../theme/stiller.dart';  // subLinkStyle için

class TumunuTemizleButon extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isPassive;

  const TumunuTemizleButon({
    super.key,
    required this.onPressed,
    this.isPassive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: isPassive ? null : onPressed,
          icon: Icon(Icons.delete, color: isPassive ? Colors.grey : mainPurple),
          label: Text(
            "Tümünü Temizle",
            style: isPassive ? const TextStyle(color: Colors.grey) : subLinkStyle,
          ),
        ),
      ),
    );
  }
}