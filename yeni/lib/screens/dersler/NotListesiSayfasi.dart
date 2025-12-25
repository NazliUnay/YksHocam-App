import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/not_service.dart';
import '../../models/not_model.dart';
import '../../data/ders_verileri.dart';

import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';

import '../../widgets/notlar/not_karti.dart';
import '../../widgets/ortak/arama_bar.dart';
import '../../widgets/notlar/not_alan_toggle.dart';
import '../../widgets/notlar/not_ders_listesi.dart';


class NotListesiSayfasi extends StatefulWidget {
  final String sayfaBasligi;
  const NotListesiSayfasi({super.key, required this.sayfaBasligi});

  @override
  State<NotListesiSayfasi> createState() => _NotListesiSayfasiState();
}

class _NotListesiSayfasiState extends State<NotListesiSayfasi> {
  final NotService _apiService = NotService();
  final TextEditingController _aramaController = TextEditingController();

  bool _aramaAcikMi = false;
  String _aramaMetni = "";

  // Seçimler
  String _seciliAlan = "TYT";
  String _seciliDers = "";
  String _ogrenciAlani = "Sayısal";

  bool _secimModu = false;
  bool _isLoading = true;
  List<NotModel> _tumNotlar = [];

  // Dinamik Ders Listesi
  List<String> get _aktifDersListesi {
    return DersVerileri.getDersler(_seciliAlan, _ogrenciAlani);
  }

  @override
  void initState() {
    super.initState();
    _tercihleriYukle();
  }

  // --- HAFIZA İŞLEMLERİ ---
  Future<void> _tercihleriYukle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ogrenciAlani = prefs.getString('alan') ?? "Sayısal";
      _seciliAlan = prefs.getString('sonSeciliAlan') ?? "TYT";

      String kayitliDers = prefs.getString('sonSeciliDers') ?? "";
      if (_aktifDersListesi.contains(kayitliDers)) {
        _seciliDers = kayitliDers;
      } else {
        _seciliDers = _aktifDersListesi.first;
      }
    });
    _verileriGetir();
  }

  Future<void> _tercihKaydet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sonSeciliAlan', _seciliAlan);
    await prefs.setString('sonSeciliDers', _seciliDers);
  }

  // --- VERİ TABANI İŞLEMLERİ ---
  Future<void> _verileriGetir() async {
    setState(() => _isLoading = true);
    var gelen = await _apiService.getNotlar(widget.sayfaBasligi);
    if (mounted) setState(() { _tumNotlar = gelen; _isLoading = false; });
  }

  // --- EKLEME İŞLEMİ ----
  void _notEklePaneliniAc() {
    String yeniNotIcerik = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Klavyenin üzerine çıkması için
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Klavye boşluğu
        ),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Üst Çizgi (Sürüklenebilir görünümü için)
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom:15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                "YENİ NOT EKLE",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainPurple),
              ),
              gapH10,
              Text(
                "$_seciliAlan - $_seciliDers",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              gapH20,
              TextField(
                autofocus: true,
                maxLines: 3,
                onChanged: (v) => yeniNotIcerik = v,
                decoration: InputDecoration(
                  hintText: "Notunuzu buraya yazın...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              gapH20,
              SizedBox(
                width: double.infinity,
                child: customElevatedButton(
                  text: "NOTU KAYDET",
                  onPressed: () async {
                    if (yeniNotIcerik.isNotEmpty) {
                      Navigator.pop(context);
                      await _notEkle(yeniNotIcerik);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _notEkle(String icerik) async {
    NotModel yeniNot = NotModel(
        icerik: icerik,
        ders: _seciliDers,
        alan: _seciliAlan,
        kategori: widget.sayfaBasligi
    );
    if (await _apiService.notEkle(yeniNot)) {
      _verileriGetir();
      showCustomSnackBar(context, "Not başarıyla eklendi!");
    }
  }

  // --- SİLME İŞLEMLERİ ---
  Future<void> _notSilDirekt(NotModel not) async {
    setState(() {
      _tumNotlar.remove(not);
    });
    await _apiService.notSil(not.id!);

    if(mounted) {
      showCustomSnackBar(context, "Not silindi", isError: true);
    }
  }

  Future<void> _secilenleriSil() async {
    showCustomDialog(
        context: context,
        title: "Seçilenleri Sil",
        content: "Seçili notlar silinsin mi?",
        positiveBtnText: "Evet, Sil",
        onPositivePressed: () async {
          for (var not in _tumNotlar.where((n) => n.seciliMi).toList()) {
            await _apiService.notSil(not.id!);
          }
          setState(() { _secimModu = false; });
          _verileriGetir();
          showCustomSnackBar(context, "Seçilenler temizlendi", isError: true);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtreleme Mantığı
    final list = _tumNotlar.where((n) =>
    n.alan == _seciliAlan &&
        n.ders == _seciliDers &&
        (_aramaMetni.isEmpty || n.icerik.toLowerCase().contains(_aramaMetni.toLowerCase()))
    ).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      // --- APPBAR ---
      appBar: _aramaAcikMi
          ? null
          : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
            widget.sayfaBasligi,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
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
      ),

      body: SafeArea(
        child: Column(
          children: [

            // ARAMA BAR MODÜLÜ
            if(_aramaAcikMi) AramaBar(
              controller: _aramaController,
              onChanged: (v) => setState(() => _aramaMetni = v),
              onKapat: () => setState(() {
                _aramaAcikMi = false;
                _aramaMetni = "";
                _aramaController.clear();
              }),
            ),

            if(!_aramaAcikMi) gapH10,

            // ALAN SEÇİM MODÜLÜ
            NotAlanToggle(
                seciliAlan: _seciliAlan,
                onAlanDegisti: (yeniAlan) {
                  setState(() {
                    _seciliAlan = yeniAlan;
                    _seciliDers = _aktifDersListesi.first;
                  });
                  _tercihKaydet();
                }
            ),

            gapH20,

            // DERS LİSTESİ MODÜLÜ
            NotDersListesi(
                dersler: _aktifDersListesi,
                seciliDers: _seciliDers,
                onDersSecildi: (secilen) {
                  setState(() => _seciliDers = secilen);
                  _tercihKaydet();
                }
            ),

            const Divider(),

            // LİSTELEME ALANI
            Expanded(
              child: _isLoading
                  ? buildLoadingWidget()
                  : list.isEmpty
                  ? buildEmptyState("Bu derse ait not bulunamadı.")
                  : ListView.separated(//elemanları dizerken otomatik ayraç
                padding: const EdgeInsets.all(20),
                itemCount: list.length,
                separatorBuilder: (c, i) => gapH20,
                itemBuilder: (context, index) {
                  final not = list[index];

                  // NOT KARTI MODÜLÜ
                  return NotKarti(
                    not: not,
                    secimModu: _secimModu,
                    onSec: (n) => setState(() {
                      n.seciliMi = !n.seciliMi;
                      _secimModu = _tumNotlar.any((x) => x.seciliMi);
                    }),
                    onSil: (n) => _notSilDirekt(n),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainPurple,
        onPressed: _secimModu ? _secilenleriSil : _notEklePaneliniAc,
        child: Icon(_secimModu ? Icons.delete : Icons.add, color: Colors.white),
      ),
    );
  }
}