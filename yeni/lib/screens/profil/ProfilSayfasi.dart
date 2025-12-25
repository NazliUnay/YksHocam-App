import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ykshocamm/theme/renkler.dart';
import '../auth/TanitimEkrani.dart';
import 'AyarlarEkrani.dart';
import '../../services/konu_service.dart';

import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';

import '../../widgets/profil/profil_header.dart';
import '../../widgets/profil/profil_isim_satiri.dart';
import '../../widgets/profil/profil_istatistik_karti.dart';

class ProfilSayfasi extends StatefulWidget {
  const ProfilSayfasi({super.key});

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  final KonuService _konuService = KonuService();

  String _adSoyad = "Yükleniyor...";
  String _kullaniciAlani = "Yükleniyor...";

  ImageProvider? _profilResmi;

  String _calismaSuresi = "- saat";
  String _bitenKonuSayisi = "- konu";

  double _yerelTytNet = 0.0;
  double _yerelAytNet = 0.0;

  final String _baseServerUrl = "http://10.0.2.2:5094";

  @override
  void initState() {
    super.initState();
    _bilgileriGuncelle();
  }

  Future<void> _bilgileriGuncelle() async {
    final prefs = await SharedPreferences.getInstance();

    final tyt = prefs.getDouble('yerel_tyt_net') ?? 0.0;
    final ayt = prefs.getDouble('yerel_ayt_net') ?? 0.0;
    final alan = prefs.getString('alan') ?? "Sayısal";

    String? sunucuFoto = prefs.getString('profilFotoUrl');
    if (sunucuFoto == "" || sunucuFoto == "null") {
      sunucuFoto = null;
    }

    final istatistikler = await _konuService.getIstatistikler();

    ImageProvider image;

    final localPath = prefs.getString('local_resim_yolu');
    if (localPath != null && localPath.isNotEmpty) {
      final file = File(localPath);
      if (file.existsSync()) {
        image = FileImage(file);
      } else {
        image = const AssetImage('assets/images/kedi_profil.png');
      }
    } else if (sunucuFoto != null && sunucuFoto.isNotEmpty) {
      final safePath = sunucuFoto.startsWith('/') ? sunucuFoto : '/$sunucuFoto';
      image = NetworkImage('$_baseServerUrl$safePath');
    } else {
      image = const AssetImage('assets/images/kedi_profil.png');
    }

    if (!mounted) return;

    setState(() {
      _adSoyad = prefs.getString('adSoyad') ?? "Öğrenci";
      _kullaniciAlani = alan;
      _profilResmi = image;

      _yerelTytNet = tyt;
      _yerelAytNet = ayt;

      _calismaSuresi = istatistikler["calisma"] ?? "0 saat";
      _bitenKonuSayisi = istatistikler["konu"] ?? "0 konu";
    });
  }

  void _netGuncellemeDialog(bool isTyt) {
    final baslik = isTyt ? "TYT Netini Gir" : "AYT Netini Gir";
    final mevcutNet = isTyt ? _yerelTytNet : _yerelAytNet;
    final controller = TextEditingController(text: mevcutNet.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(baslik),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: "Örn: 75.5",
            suffixText: isTyt ? "TYT" : "AYT",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final yeniNet = double.tryParse(controller.text) ?? 0.0;
              final prefs = await SharedPreferences.getInstance();

              if (isTyt) {
                await prefs.setDouble('yerel_tyt_net', yeniNet);
                setState(() => _yerelTytNet = yeniNet);
              } else {
                await prefs.setDouble('yerel_ayt_net', yeniNet);
                setState(() => _yerelAytNet = yeniNet);
              }
              Navigator.pop(context);
            },
            child: const Text("Güncelle"),
          ),
        ],
      ),
    );
  }

  void _ayarlariAc() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AyarlarEkrani()),
    ).then((_) => _bilgileriGuncelle());
  }

  void _cikisYap() {
    showCustomDialog(
      context: context,
      title: "Çıkış Yap",
      content: "Hesabından çıkış yapmak istediğine emin misin?",
      positiveBtnText: "Çıkış Yap",
      onPositivePressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const TanitimEkrani()),
          (_) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _bilgileriGuncelle,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                ProfilHeader(onCikisYap: _cikisYap),
                gapH30,
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: mainPurple, width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _profilResmi,
                  ),
                ),
                gapH20,
                ProfilIsimSatiri(adSoyad: _adSoyad, onTap: _ayarlariAc),
                Text(
                  "Alan: $_kullaniciAlani",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                gapH30,
                ProfilIstatistikKarti(
                  baslik: "Toplam Çalışma Süresi",
                  deger: _calismaSuresi,
                ),
                gapH20,
                ProfilIstatistikKarti(
                  baslik: "Bitirilen Konu Sayısı",
                  deger: _bitenKonuSayisi,
                ),
                gapH20,
                // Net Durumu Kartı (Yenilenmiş Tasarım)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: mainPurple,
                    borderRadius: BorderRadius.circular(20), // Oval tasarım
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _netGuncellemeDialog(true),
                              behavior: HitTestBehavior.opaque,
                              child: _buildNetSubItem("TYT", "$_yerelTytNet"),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 1.5,
                            color: Colors.grey.withOpacity(0.15),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _netGuncellemeDialog(false),
                              behavior: HitTestBehavior.opaque,
                              child: _buildNetSubItem(
                                "AYT ($_kullaniciAlani)",
                                "$_yerelAytNet",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                gapH10,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Net alt öğeleri için yardımcı fonksiyon
  Widget _buildNetSubItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
