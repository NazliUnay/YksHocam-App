import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/bildirim_service.dart'; // Bildirim kontrolü için
import '../../services/plan_service.dart';     // Sınav tarihi için
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';

import '../dersler/NotlarSayfasi.dart';
import '../planlama/TakvimSayfasi.dart';
import '../planlama/PlanSayfasi.dart';
import '../profil/ProfilSayfasi.dart';
import '../bildirimler/BildirimlerEkrani.dart';
import '../dersler/KonuListesiSayfasi.dart';
import '../dersler/PomodoroSayfasi.dart';
import '../aliskanliklar/AliskanliklarSayfasi.dart';

// WIDGET IMPORTLARI
import '../../widgets/anasayfa/ana_sayfa_header.dart';
import '../../widgets/anasayfa/sayac_karti.dart';
import '../../widgets/anasayfa/ana_sayfa_menu_kart.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final BildirimService _bildirimService = BildirimService();
  final PlanService _planService = PlanService();

  String adSoyad = "";
  int _seciliIndex = 2; // Varsayılan olarak Ana Sayfa (Ortadaki)
  DateTime? _targetDate;
  Duration _kalanSure = Duration.zero;
  Timer? _timer;
  bool _bildirimVarMi = false;

  @override
  void initState() {
    super.initState();
    _kullaniciBilgileriniGetir();
    _loadExamDate();//sınav tarihini servisten çeker
    _bildirimKontrol();
  }

  @override
  void dispose() {//sayfa kapanırken
    _timer?.cancel();// Sayfa kapanırken sayacı durdurur.
    //sayaç arka planda sayması gerksiz
    super.dispose();
  }

  // --- API VE VERİ İŞLEMLERİ ---
  Future<void> _bildirimKontrol() async {
    var liste = await _bildirimService.getBildirimler();
    if (mounted) {
      setState(() {
        _bildirimVarMi = liste.isNotEmpty;
      });
    }
  }

  Future<void> _kullaniciBilgileriniGetir() async {
    // Burası yerel depolama olduğu için servise gerek yok
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String tamIsim = prefs.getString('adSoyad') ?? "Öğrenci";
      adSoyad = tamIsim.split(" ")[0];
    });
  }

  void _loadExamDate() async {
    var data = await _planService.getSinavTarihi();
    if (data != null && data['tarih'] != null) {
      setState(() { //ekranda değişiklik var
        _targetDate = DateTime.parse(data['tarih']);
      });
      _startTimer();
    }
  }

  void _startTimer() {
    if (_targetDate == null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_targetDate == null || !mounted) return; //Widget var mı ekranda

      final simdi = DateTime.now();
      if (simdi.isAfter(_targetDate!)) {
        timer.cancel();
        setState(() => _kalanSure = Duration.zero);
      } else {
        setState(() {
          _kalanSure = _targetDate!.difference(simdi);
        });
      }
    });
  }

  // --- NAVİGASYON ---
  void _onItemTapped(int index) {
    setState(() => _seciliIndex = index);
    if (index == 2) {
      _bildirimKontrol();
    }
  }

  Widget _sayfaGetir() {
    switch (_seciliIndex) {
      case 0: return const NotlarSayfasi();
      case 1: return const TakvimSayfasi();
      case 2: return _buildHomeContent();
      case 3: return const PlanSayfasi();
      case 4: return const ProfilSayfasi();
      default: return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _sayfaGetir()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainPurple,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _seciliIndex,
        iconSize: 28,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Notlar"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Takvim"),
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Plan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  // --- ANA SAYFA İÇERİĞİ ---
  Widget _buildHomeContent() {
    return SingleChildScrollView(//kaydırma
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ÜST HEADER
          AnaSayfaHeader(
            adSoyad: adSoyad,
            bildirimVarMi: _bildirimVarMi,
            onBildirimTikla: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BildirimlerEkrani()))
                  .then((_) => _bildirimKontrol());
            },
          ),

          gapH20,

          // SAYAÇ KARTI
          SayacKarti(
            targetDate: _targetDate,
            kalanSure: _kalanSure,
          ),

          gapH30,

          // MENÜ KARTLARI
          AnaSayfaMenuKart(
            title: "KONU LİSTELERİ",
            imagePath: "assets/images/konu_listesi.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KonuListesiSayfasi())),
          ),
          gapH10,
          AnaSayfaMenuKart(
            title: "POMODORO",
            imagePath: "assets/images/pomodoro.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PomodoroSayfasi())),
          ),
          gapH10,
          AnaSayfaMenuKart(
            title: "ALIŞKANLIKLAR",
            imagePath: "assets/images/aliskanliklar.png",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AliskanliklarSayfasi())),
          ),
        ],
      ),
    );
  }
}