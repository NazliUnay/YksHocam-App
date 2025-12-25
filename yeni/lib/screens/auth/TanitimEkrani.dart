import 'package:flutter/material.dart';
import 'GirisEkrani.dart';
import 'KayitEkrani.dart';
import '../../theme/renkler.dart';           // mainPurple için
import '../../theme/stiller.dart';           // headerStyle, gapH20 için
import '../../widgets/ortak/ortak_bilesenler.dart'; // customElevatedButton, customNavigationLink için

class TanitimEkrani extends StatelessWidget {
  const TanitimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekranın toplam yüksekliğini alarak görsel boyutlarını orantılıyoruz
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Sade beyaz arka plan
      body: SafeArea(
        child: LayoutBuilder(//ekrana göre farklı boyutlar
          builder: (context, constraints) {//enine boyunu
            return SingleChildScrollView(
              // Küçük ekranlarda içeriğin kaydırılabilmesini sağlar (Pixel Overflow hatasını önler)
              child: ConstrainedBox(//alt üst limitler
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(//ihtiyacı olan ne kadar boyu varsa onu ver
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      children: [
                        // --- ÜST BÖLÜM: Uygulama İsmi ve Hızlı Geçiş İkonu ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // theme/stiller.dart içindeki headerStyle (Büyük YKS yazısı)
                                const Text('YKS', style: headerStyle),
                                // Metinleri birbirine yaklaştırmak için hafif yukarı kaydırıyoruz
                                Transform.translate(//kordinatları değiştirirken belili bir yere kaydıormak
                                  offset: const Offset(0, -10),
                                  child: const Text(
                                    'Yanımda',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Sağ üstteki mor ok ikonu
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const GirisEkrani()),
                              ),
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: mainPurple,
                                size: 60,//ikon boyutu
                              ),
                            ),
                          ],
                        ),

                        // Esnek boşluk: Görseli dikeyde dengeler
                        const Spacer(flex: 1),

                        // --- ORTA BÖLÜM: Ana Maskot Görseli ---
                        Container(
                          // Görselin ekranın %40'ından fazla yer kaplamasını engeller
                          constraints: BoxConstraints(maxHeight: ekranYuksekligi * 0.40),
                          child: Image.asset(
                            'assets/images/owl.png',
                            fit: BoxFit.contain,//bozmadan ve dışarı taşmadan
                          ),
                        ),

                        // Esnek boşluk: Butonları ekranın altına doğru iter
                        const Spacer(flex: 1),

                        // --- ALT BÖLÜM: Aksiyon Butonları ---
                        SizedBox(
                          width: double.infinity, // Butonun tam genişlikte olmasını sağlar
                          // widgets/ortak/ortak_bilesenler.dart
                          child: customElevatedButton(
                            text: "Giriş",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const GirisEkrani()),
                              );
                            },
                          ),
                        ),

                        gapH20, // theme/stiller.dart

                        // "Hesabın yok mu? Kayıt ol" link yapısı (ortak_bilesenler.dart)
                        customNavigationLink(
                          text: "Hesabın yok mu? ",
                          linkText: "Kayıt ol",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const KayitEkrani()),
                            );
                          },
                        ),

                        gapH20, // Alt kenar boşluğu
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}