import 'package:flutter/material.dart';
import 'NotListesiSayfasi.dart';
import '../../theme/stiller.dart'; // headerStyle, gapH20, gapH30 için
import '../../widgets/notlar/not_kategori_karti.dart';

class NotlarSayfasi extends StatelessWidget {
  const NotlarSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BAŞLIK ---
              const Text(
                "Notlar",
                style: headerStyle, // theme/stiller.dart'tan geliyor
              ),

              gapH30,

              // --- KARTLAR ---

              // Kart: Hap Bilgiler
              NotKategoriKarti(
                title: "HAP BİLGİLER",
                imagePath: "assets/images/hapBilgiler.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotListesiSayfasi(sayfaBasligi: "Hap Bilgiler")
                    ),
                  );
                },
              ),

              gapH20,

              // Kart: Karıştırdığım Bilgiler
              NotKategoriKarti(
                title: "KARIŞTIRDIĞIM BİLGİLER",
                imagePath: "assets/images/karistirdigimBilgiler.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotListesiSayfasi(sayfaBasligi: "Karıştırdığım Bilgiler")
                    ),
                  );
                },
              ),

              gapH20,

              // Kart: Hep Unutuyorum
              NotKategoriKarti(
                title: "HEP UNUTUYORUM",
                imagePath: "assets/images/hepUnutuyorum.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotListesiSayfasi(sayfaBasligi: "Hep Unutuyorum")
                    ),
                  );
                },
              ),

              gapH20, // Alt boşluk
            ],
          ),
        ),
      ),
    );
  }
}