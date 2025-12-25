import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class ProfilResmiBolumu extends StatelessWidget {
  final File? secilenDosya;      // Yeni seçilen yerel dosya
  final String? profilFotoUrl;   // Veritabanından gelen URL
  final VoidCallback onResimDegistir;
  final VoidCallback onResimBuyut;

  const ProfilResmiBolumu({
    super.key,
    required this.secilenDosya,
    this.profilFotoUrl, // Parametre olarak ekledik
    required this.onResimDegistir,
    required this.onResimBuyut,
  });

  // Resim Karar Mekanizması
  ImageProvider _getProfileImage() {
    // ÖNCELİK: Kullanıcı o an yeni bir resim seçtiyse (File)
    if (secilenDosya != null) {
      return FileImage(secilenDosya!);
    }

    // ÖNCELİK: Veritabanında bir URL varsa (Network)
    if (profilFotoUrl != null &&
        profilFotoUrl != "default" &&
        profilFotoUrl!.isNotEmpty) {

      const String baseServerUrl = "http://10.0.2.2:5094";
      return NetworkImage("$baseServerUrl$profilFotoUrl");
    }

    // ÖNCELİK: Hiçbiri yoksa varsayılan resim (Asset)
    return const AssetImage('assets/images/kedi_profil.png');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // Düzenli görünüm için merkeze aldık
      children: [
        GestureDetector(
          onTap: onResimBuyut,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: mainPurple.withOpacity(0.3), width: 2),
              image: DecorationImage(
                image: _getProfileImage(), // Dinamik resmi buradan alıyor
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0, // Edit ikonunu sağ alta almak daha yaygın bir tasarımdır
          right: 5,
          child: GestureDetector(
            onTap: onResimDegistir,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  )
                ],
              ),
              child: const Icon(Icons.camera_alt, color: mainPurple, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}