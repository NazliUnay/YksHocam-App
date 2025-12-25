import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';
import 'GunlukPlanEkrani.dart';

import '../../theme/renkler.dart';  // mainPurple için
import '../../theme/stiller.dart';  // headerStyle, gapH20 için

import '../../widgets/plan/plan_gun_karti.dart';

class PlanSayfasi extends StatefulWidget {
  const PlanSayfasi({super.key});

  @override
  State<PlanSayfasi> createState() => _PlanSayfasiState();
}

class _PlanSayfasiState extends State<PlanSayfasi> {
  List<DateTime> _gunler = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null).then((_) {
      _gunleriOlustur();
    });
  }

  void _gunleriOlustur() {
    DateTime bugun = DateTime.now();
    // Haftanın Pazartesi gününü bul
    DateTime ptesi = bugun.subtract(Duration(days: bugun.weekday - 1));

    setState(() {
      _gunler.clear();
      for (int i = 0; i < 7; i++) {
        _gunler.add(ptesi.add(Duration(days: i)));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    DateTime bugun = DateTime.now();
    // Karşılaştırma için bugünün saatlerini sıfırlıyoruz
    DateTime bugunSifir = DateTime(bugun.year, bugun.month, bugun.day);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("PLAN", style: headerStyle),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _gunler.length,
                      separatorBuilder: (c, i) => gapH20,
                      itemBuilder: (context, index) {
                        final tarih = _gunler[index];
                        final tarihSifir = DateTime(
                            tarih.year, tarih.month, tarih.day);

                        // Eğer tarih bugünden önceyse veya bugünse TRUE döner
                        bool mordaKalsin = tarihSifir.isBefore(bugunSifir) ||
                            tarihSifir.isAtSameMomentAs(bugunSifir);

                        return PlanGunKarti(
                          tarih: tarih,
                          isPastOrToday: mordaKalsin,
                          // <--- Hesapladığımız bilgiyi buraya verdik
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GunlukPlanEkrani(secilenTarih: tarih),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            buildSideDecorator(),
          ],
        ),
      ),
    );
  }
}