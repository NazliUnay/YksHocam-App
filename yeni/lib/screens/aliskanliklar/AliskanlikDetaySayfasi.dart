import 'package:flutter/material.dart';
import '../../services/aliskanlik_service.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';
import '../../data/tarih_verileri.dart'; // TarihVerileri ve extension burada olmalı
import '../../widgets/ortak/ortak_bilesenler.dart';
import '../../widgets/aliskanliklar/aliskanlik_gun_daire.dart';

class AliskanlikDetaySayfasi extends StatefulWidget {
  final int habitId;
  final String habitName;

  const AliskanlikDetaySayfasi({
    super.key,
    required this.habitId,
    required this.habitName,
  });

  @override
  State<AliskanlikDetaySayfasi> createState() => _AliskanlikDetaySayfasiState();
}

class _AliskanlikDetaySayfasiState extends State<AliskanlikDetaySayfasi> {
  final AliskanlikService _apiService = AliskanlikService();
  Map<int, Set<int>> yearlyCompletedDays = {};
  //set sayesinde gün tekrarlanmaz
  //aylar key, tamalanan günler value
  bool isLoading = true;
  final int currentYear = DateTime.now().year; //şu anki yıl

  @override
  void initState() {//tum sayfa çalıştığında çalışır
    super.initState();
    _tumYiliGetir();
  }
  //şu an elimde olmayan ama birazdan gelecek olan veri
  Future<void> _tumYiliGetir() async {
    setState(() => isLoading = true);
    try {
      // 12 isteği aynı anda başlatır, hepsi bitince devam eder
      //paralelilik hız
      await Future.wait(List.generate(12, (index) async {
        int ay = index + 1;
        Set<int> gelenGunler = await _apiService.getTamamlananGunler(
            widget.habitId, currentYear, ay);
        yearlyCompletedDays[ay] = gelenGunler;
      }));
    } catch (e) {
      debugPrint("Hata: $e");
    }
    if (mounted) setState(() => isLoading = false); //hayatta mı
  }

  Future<void> _gunIsaretle(int ay, int gun) async {
    DateTime secilenTarih = DateTime(currentYear, ay, gun);

    setState(() {
      yearlyCompletedDays[ay] ??= {};
      if (yearlyCompletedDays[ay]!.contains(gun)) {
        yearlyCompletedDays[ay]!.remove(gun);
      } else {
        yearlyCompletedDays[ay]!.add(gun);
      }
    });

    bool basarili = await _apiService.gunIsaretle(widget.habitId, secilenTarih);

    if (!basarili && mounted) {
      _tumYiliGetir();
      showCustomSnackBar(context, "Sunucu bağlantı hatası!", isError: true);
    }
    //_gunIsaretle fonksiyonunda önce arayüzü günceller (setState),
    // ardından sunucuya istek atar.
    // Eğer sunucu işlemi başarısız olursa veriyi
    // eski haline getirmek için tekrar _tumYiliGetir() fonksiyonunu çağırır.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//iskele
      backgroundColor: Colors.white,
      appBar: customAppBar(context, widget.habitName.toUpperCase()),
      body: isLoading
          ? buildLoadingWidget()
          : Row(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: 12,
              itemBuilder: (context, index) {
                int ayNumarasi = index + 1;
                return _buildAyBolumu(ayNumarasi);
              },
            ),
          ),
          buildSideDecorator(),
        ],
      ),
    );
  }

  Widget _buildAyBolumu(int ay) {
    // Kendi yazdığın extension'ı kullanarak ay ismini alıyoruz
    String ayIsmi = DateTime(currentYear, ay).ayIsmi.toUpperCase();
    int gunSayisi = DateUtils.getDaysInMonth(currentYear, ay);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "$ayIsmi $currentYear",
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: mainPurple
            ),
          ),
        ),
        _buildSnakeGrid(ay, gunSayisi),
        const SizedBox(height: 30),
        Divider(color: Colors.grey.withOpacity(0.2), indent: 40, endIndent: 40),
      ],
    );
  }

  Widget _buildSnakeGrid(int ay, int gunSayisi) {
    const int itemsPerRow = 7;
    List<Widget> rows = [];

    List<Widget> gunListesi = List.generate(gunSayisi, (index) {
      int gunNum = index + 1;
      bool isCompleted = yearlyCompletedDays[ay]?.contains(gunNum) ?? false;

      return AliskanlikGunDaire(
        gun: gunNum,
        tamamlandiMi: isCompleted,
        onTap: () => _gunIsaretle(ay, gunNum),
      );
    });

    for (int i = 0; i < gunListesi.length; i += itemsPerRow) {
      int end = (i + itemsPerRow < gunListesi.length) ? i + itemsPerRow : gunListesi.length;
      List<Widget> rowItems = gunListesi.sublist(i, end);
      bool isReversed = (i ~/ itemsPerRow) % 2 == 1; //yon ddeğiştirme

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: isReversed ? rowItems.reversed.toList() : rowItems,
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}