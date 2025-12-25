import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ykshocamm/theme/renkler.dart';
class AnaSayfaHeader extends StatefulWidget {
  final String adSoyad;
  final String? profilFotoUrl;
  final bool bildirimVarMi;
  final VoidCallback onBildirimTikla;

  const AnaSayfaHeader({
    super.key,
    required this.adSoyad,
    this.profilFotoUrl,
    required this.bildirimVarMi,
    required this.onBildirimTikla,
  });

  @override
  State<AnaSayfaHeader> createState() => _AnaSayfaHeaderState();
}

class _AnaSayfaHeaderState extends State<AnaSayfaHeader> {
  final String baseUrl = "http://10.0.2.2:5094";

  ImageProvider? _profilResmi;

  @override
  void initState() {
    super.initState();
    _profilResminiHazirla();
  }

  Future<void> _profilResminiHazirla() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ImageProvider? image;

    // Yerel dosya (Ayarlar ekranından)
    final localPath = prefs.getString('local_resim_yolu');
    if (localPath != null && localPath.isNotEmpty) {
      final file = File(localPath);
      if (file.existsSync()) {
        image = FileImage(file);
      }
    }

    // Backend URL
    if (image == null &&
        widget.profilFotoUrl != null &&
        widget.profilFotoUrl!.isNotEmpty) {
      final safePath = widget.profilFotoUrl!.startsWith('/')
          ? widget.profilFotoUrl!
          : '/${widget.profilFotoUrl}';
      image = NetworkImage('$baseUrl$safePath');
    }

    // Varsayılan (sadece hiçbiri yoksa)
    image ??= const AssetImage('assets/images/kedi_profil.png');

    if (mounted) {
      setState(() {
        _profilResmi = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mainPurple, width: 1.2),
                ),
                child: _profilResmi == null
                    ? const SizedBox(width: 60, height: 60)
                    : CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: _profilResmi,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "İyi Çalışmalar, ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.adSoyad.isEmpty ? "Öğrenci" : widget.adSoyad,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildBildirimButonu(),
      ],
    );
  }

  Widget _buildBildirimButonu() {
    return GestureDetector(
      onTap: widget.onBildirimTikla,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 0.8),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            const Icon(Icons.notifications, size: 28, color: Colors.black),
            if (widget.bildirimVarMi)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
