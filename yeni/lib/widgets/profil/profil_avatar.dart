import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class ProfilAvatar extends StatelessWidget {
  final ImageProvider imageProvider;
  final VoidCallback onEdit;

  const ProfilAvatar({
    super.key,
    required this.imageProvider,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: mainPurple.withOpacity(0.2), width: 3),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}