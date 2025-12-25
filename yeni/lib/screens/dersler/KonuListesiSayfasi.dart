import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ykshocamm/services/konu_service.dart';
import '../../models/konu_model.dart';
import '../../services/konu_service.dart';
import '../../data/ders_verileri.dart';

import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';

import '../../widgets/ortak/arama_bar.dart';
import '../../widgets/konu_takip/konu_ders_menu.dart';
import '../../widgets/konu_takip/konu_karti.dart';
import '../../widgets/konu_takip/konu_ilerleme_karti.dart';

class KonuListesiSayfasi extends StatefulWidget {
  const KonuListesiSayfasi({super.key});

  @override
  State<KonuListesiSayfasi> createState() => _KonuListesiSayfasiState();
}

class _KonuListesiSayfasiState extends State<KonuListesiSayfasi> {
  final KonuService _apiService = KonuService();
  final TextEditingController _aramaController = TextEditingController();

  bool _isLoading = true;
  bool _aramaAcikMi = false;
  String _aramaMetni = "";
  String _seciliAlan = "TYT";
  String _seciliDers = "";
  String _ogrenciAlani = "Sayısal";
  List<KonuModel> _konular = [];

  List<String> get _aktifDersListesi => DersVerileri.getDersler(_seciliAlan, _ogrenciAlani);

  @override
  void initState() {
    super.initState();
    _kullaniciBilgileriniVeVerileriGetir();
  }

  Future<void> _kullaniciBilgileriniVeVerileriGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ogrenciAlani = prefs.getString('alan') ?? "Sayısal";
      _seciliDers = _aktifDersListesi.first;
    });
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    setState(() => _isLoading = true);
    var gelenKonular = await _apiService.getKonular(_seciliAlan, _seciliDers);
    if (mounted) {
      setState(() {
        _konular = gelenKonular;
        _isLoading = false;
      });
    }
  }

  List<KonuModel> get _filtreliKonular {
    if (_aramaMetni.isEmpty) return _konular;
    return _konular.where((konu) => konu.ad.toLowerCase().contains(_aramaMetni.toLowerCase())).toList();
  }

  double get _tamamlanmaOrani {
    if (_konular.isEmpty) return 0.0;
    int tamamlanan = _konular.where((k) => k.tamamlandiMi).length;
    return (tamamlanan / _konular.length);
  }

  // Alan Toggle Butonu (Sayfa içinde bırakıldı)
  Widget _buildAlanToggleButton(String text, bool isActive) {
    return Expanded(
      child: GestureDetector(//dokunmatik
        onTap: () {
          setState(() {
            _seciliAlan = text;
            _seciliDers = _aktifDersListesi.first;
          });
          _verileriGetir();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: isActive ? mainPurple : Colors.transparent,
              borderRadius: BorderRadius.circular(30)
          ),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _aramaAcikMi ? null : customAppBar(context, "KONU LİSTELERİ") // Ortak bileşen kullanıldı
          .preferredSize.height == kToolbarHeight
      // AppBar actions özelleştirmesi gerektiği için manuel AppBar yapıyoruz
          ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("KONU LİSTELERİ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: mainPurple),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: mainPurple, size: 28),
            onPressed: () => setState(() => _aramaAcikMi = true),
          ),
          const SizedBox(width: 15),
        ],
      )
          : null,

      body: SafeArea(
        child: Column(
          children: [

            // 1. ARAMA BAR
            if (_aramaAcikMi) AramaBar(
              controller: _aramaController,
              onChanged: (v) => setState(() => _aramaMetni = v),
              onKapat: () => setState(() {
                _aramaAcikMi = false;
                _aramaMetni = "";
                _aramaController.clear();
              }),
            ),

            if (!_aramaAcikMi) gapH10,

            // ALAN TOGGLE (TYT/AYT)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  _buildAlanToggleButton("TYT", _seciliAlan == "TYT"),
                  _buildAlanToggleButton("AYT", _seciliAlan == "AYT"),
                ],
              ),
            ),

            gapH20,

            // DERS MENÜSÜ
            KonuDersMenu(
                dersler: _aktifDersListesi,
                seciliDers: _seciliDers,
                onDersSecildi: (secilen) {
                  setState(() => _seciliDers = secilen);
                  _verileriGetir();
                }
            ),

            const Divider(),

            // KONU LİSTESİ
            Expanded(
              child: _isLoading
                  ? buildLoadingWidget()
                  : _filtreliKonular.isEmpty
                  ? buildEmptyState("Aranan konu bulunamadı.")
                  : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: _filtreliKonular.length,
                separatorBuilder: (c, i) => gapH10,
                itemBuilder: (context, index) {
                  final konu = _filtreliKonular[index];

                  // KONU KARTI WIDGET
                  return KonuKarti(
                    konu: konu,
                    onDurumDegisti: (val) async {
                      setState(() => konu.tamamlandiMi = val ?? false);
                      bool basarili = await _apiService.konuDurumGuncelle(konu.id!, val ?? false);
                      if (!basarili && mounted) {
                        setState(() => konu.tamamlandiMi = !(val ?? false));
                        showCustomSnackBar(context, "Durum güncellenemedi.", isError: true);
                      }
                    },
                  );
                },
              ),
            ),

            // İLERLEME KARTI
            KonuIlerlemeKarti(oran: _tamamlanmaOrani),
          ],
        ),
      ),
    );
  }
}