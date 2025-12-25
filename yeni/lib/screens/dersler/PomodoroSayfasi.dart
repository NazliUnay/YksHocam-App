import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import '../../services/pomodoro_service.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';
import '../../widgets/pomodoro/pomodoro_timer_gostergesi.dart';
import '../../widgets/pomodoro/pomodoro_part_karti.dart';

class PomodoroSayfasi extends StatefulWidget {
  const PomodoroSayfasi({super.key});

  @override
  State<PomodoroSayfasi> createState() => _PomodoroSayfasiState();
}

class _PomodoroSayfasiState extends State<PomodoroSayfasi>
    with WidgetsBindingObserver {
  final PomodoroService _apiService = PomodoroService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _calismaDakika = 60;
  int _molaDakika = 15;
  bool _molaModu = false;
  late int _kalanSaniye;

  Timer? _timer;
  bool _calisiyor = false;

  String _suAnkiDers = "";
  final List<dynamic> _tamamlananDersler = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _kalanSaniye = _calismaDakika * 60;

    _ayarlariVeSayaciYukle().then((_) {
      _verileriGetir();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _ayarlariVeSayaciYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _calismaDakika = prefs.getInt('calismaSure') ?? 60;
      _molaDakika = prefs.getInt('molaSure') ?? 15;
      _kalanSaniye = prefs.getInt('sonKalanSaniye') ?? (_calismaDakika * 60);
      _suAnkiDers = prefs.getString('suAnkiDers') ?? "";
      _calisiyor = prefs.getBool('calisiyor') ?? false;
      _molaModu = prefs.getBool('molaModu') ?? false;
    });

    if (_calisiyor && _kalanSaniye > 0) {
      _sayaciBaslat(otomatik: true);
    }
  }

  Future<void> _durumuKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calismaSure', _calismaDakika);
    await prefs.setInt('molaSure', _molaDakika);
    await prefs.setInt('sonKalanSaniye', _kalanSaniye);
    await prefs.setString('suAnkiDers', _suAnkiDers);
    await prefs.setBool('calisiyor', _calisiyor);
    await prefs.setBool('molaModu', _molaModu);
  }

  Future<void> _verileriGetir() async {
    final gecmis = await _apiService.getBugunPomodoroGecmisi();
    if (gecmis != null) {
      setState(() {
        _tamamlananDersler.clear();
        _tamamlananDersler.addAll(gecmis);
      });
    }
  }

  void _etuduSil(int index) {
    final etut = _tamamlananDersler[index];
    final int id = etut['oturumId'];

    showCustomDialog(
      context: context,
      title: "Etüdü Sil",
      content: "'${etut['calisilanKonu']}' etüdünü silmek istediğine emin misin?",
      positiveBtnText: "Sil",
      onPositivePressed: () async {
        bool sonuc = await _apiService.silPomodoro(id);
        if (sonuc) {
          await _verileriGetir();
          if (mounted) showCustomSnackBar(context, "Etüt başarıyla silindi");
        }
      },
    );
  }

  void _baslatDurdur() {
    if (_calisiyor) {
      _timer?.cancel();
      setState(() => _calisiyor = false);
      _durumuKaydet();
    } else {
      if (!_molaModu && _kalanSaniye == _calismaDakika * 60) {
        _hedefSorVeBaslat();
      } else {
        _sayaciBaslat();
      }
    }
  }

  void _sayaciBaslat({bool otomatik = false}) {
    if (!otomatik) setState(() => _calisiyor = true);
    _durumuKaydet();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_kalanSaniye > 0) {
        setState(() => _kalanSaniye--);
        if (_kalanSaniye % 10 == 0) _durumuKaydet();
      } else {
        _timer?.cancel();
        _oturumBitir();
      }
    });
  }

  Future<void> _oturumBitir() async {
    if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 800);
    _audioPlayer.play(AssetSource('sounds/alarm.mp3'));

    if (!_molaModu) {
      // ÇALIŞMA BİTTİ -> KAYDET VE MOLAYI HAZIRLA
      bool sonuc = await _apiService.kaydetPomodoro(
        calisilanKonu: _suAnkiDers,
        sure: _calismaDakika,
        tarih: DateTime.now(),
      );
      if (sonuc) await _verileriGetir();

      setState(() {
        _molaModu = true;
        _kalanSaniye = _molaDakika * 60;
        _calisiyor = true; // Molayı otomatik başlatır
      });
      _sayaciBaslat(otomatik: true);
    } else {
      // MOLA BİTTİ
      setState(() {
        _molaModu = false;
        _calisiyor = false;
        _kalanSaniye = _calismaDakika * 60;
        _suAnkiDers = "";
      });
      if (mounted) showCustomSnackBar(context, "Mola bitti! Yeni etüde hazır mısın?");
    }
    _durumuKaydet();
  }

  void _hedefSorVeBaslat() {
    String hedef = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("BU ETÜTTE NE ÇALIŞACAKSIN?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: mainPurple)),
              gapH20,
              TextField(
                autofocus: true,
                onChanged: (v) => hedef = v,
                decoration: customInputDecoration(label: "Örn: Matematik 20 Soru", icon: Icons.edit),
              ),
              gapH20,
              SizedBox(
                width: double.infinity,
                child: customElevatedButton(
                  text: "ODAKLANMAYI BAŞLAT",
                  onPressed: () {
                    setState(() {
                      _suAnkiDers = hedef.isEmpty ? "Genel Çalışma" : hedef;
                    });
                    Navigator.pop(context);
                    _sayaciBaslat();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ayarlariGoster() {
    int c = _calismaDakika;
    int m = _molaDakika;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModal) => Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Süre Ayarları", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              gapH20,
              _ayarSatiri("Çalışma", c, (v) => setModal(() => c = v)),
              _ayarSatiri("Mola", m, (v) => setModal(() => m = v)),
              gapH20,
              SizedBox(
                width: double.infinity,
                child: customElevatedButton(
                  text: "KAYDET",
                  onPressed: () {
                    setState(() {
                      _calismaDakika = c;
                      _molaDakika = m;
                      _kalanSaniye = c * 60;
                      _timer?.cancel();
                      _calisiyor = false;
                      _suAnkiDers = "";
                      _molaModu = false;
                    });
                    _durumuKaydet();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _ayarSatiri(String title, int val, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            IconButton(onPressed: () => val > 1 ? onChanged(val - 1) : null, icon: const Icon(Icons.remove, color: mainPurple)),
            Text("$val", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => onChanged(val + 1), icon: const Icon(Icons.add, color: mainPurple)),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "POMODORO"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              gapH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tamamlanan Etütler: ${_tamamlananDersler.length}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: _ayarlariGoster, icon: const Icon(Icons.settings)),
                ],
              ),
              gapH20,
              Text(
                _molaModu ? "MOLA ZAMANI" : "ÇALIŞMA ZAMANI",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _molaModu ? Colors.green : mainPurple
                ),
              ),
              gapH10,
              PomodoroTimerGostergesi(
                toplamSaniye: (_molaModu ? _molaDakika : _calismaDakika) * 60,
                kalanSaniye: _kalanSaniye,
              ),
              gapH20,
              SizedBox(
                width: double.infinity,
                child: customElevatedButton(
                  text: _calisiyor
                      ? "DURDUR"
                      : (_molaModu ? "MOLAYI BAŞLAT" : "BAŞLAT"),
                  onPressed: _baslatDurdur,
                ),
              ),
              gapH30,
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // Toplam eleman sayısı: Tamamlananlar + (Eğer şu an bir ders varsa 1)
                itemCount: _tamamlananDersler.length + ((_calisiyor || _suAnkiDers.isNotEmpty) && !_molaModu ? 1 : 0),
                itemBuilder: (context, index) {
                  // Aktif Çalışma Kontrolü
                  bool aktifCalismaVar = (_calisiyor || _suAnkiDers.isNotEmpty) && !_molaModu;

                  // Eğer en üstte aktif bir çalışma gösterilecekse
                  if (aktifCalismaVar && index == 0) {
                    return PomodoroPartKarti(
                      dersAdi: _suAnkiDers.isEmpty ? "Odaklanılıyor..." : _suAnkiDers,
                      partNo: "$_calismaDakika dk • Şimdi", // Aktif ders için "Şimdi" ibaresi
                      tamamlandiMi: false,
                    );
                  }

                  // Tamamlanan Etütlerin İndeksini Hesapla
                  // Aktif çalışma varsa liste 1 kayar, bu yüzden index-1 yapıyoruz
                  final listeIndeksi = aktifCalismaVar ? index - 1 : index;

                  // LİSTEYİ TERS ÇEVİRME: Listenin sonundaki elemanı (en yeniyi) en üstte göster
                  // API'den gelen liste [Eski, Orta, Yeni] ise biz [Yeni, Orta, Eski] olarak okuyoruz
                  final tersIndeks = (_tamamlananDersler.length - 1) - listeIndeksi;
                  final etut = _tamamlananDersler[tersIndeks];

                  // Saat Formatlama
                  String saatBilgisi = "";
                  try {
                    if (etut['tarih'] != null) {
                      // API'den gelen string'i DateTime'a çeviriyoruz
                      DateTime tarih = DateTime.parse(etut['tarih'].toString());
                      // HH:mm formatı (Örn: 14:45)
                      saatBilgisi = "${tarih.hour.toString().padLeft(2, '0')}:${tarih.minute.toString().padLeft(2, '0')}";
                    }
                  } catch (e) {
                    saatBilgisi = "--:--";
                  }

                  return InkWell(
                    // Silme işlemi için tersIndeks kullanıyoruz ki doğru ID'li etüt silinsin
                    onLongPress: () => _etuduSil(tersIndeks),
                    borderRadius: BorderRadius.circular(20),
                    child: PomodoroPartKarti(
                      dersAdi: etut['calisilanKonu'].toString(),
                      partNo: "${etut['sureDakika']} dk - $saatBilgisi",
                      tamamlandiMi: true,
                    ),
                  );
                },
              ),
              gapH30,
            ],
          ),
        ),
      ),
    );
  }
}