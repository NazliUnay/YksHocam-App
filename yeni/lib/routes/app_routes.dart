import 'package:flutter/material.dart';
import '../screens/auth/TanitimEkrani.dart';
import '../screens/auth/GirisEkrani.dart';
import '../screens/auth/KayitEkrani.dart';
import '../screens/anasayfa/AnaSayfa.dart';
import '../screens/profil/ProfilSayfasi.dart';
import '../screens/profil/AyarlarEkrani.dart';
import '../screens/planlama/PlanSayfasi.dart';
import '../screens/planlama/TakvimSayfasi.dart';
import '../screens/dersler/PomodoroSayfasi.dart';
import '../screens/aliskanliklar/AliskanliklarSayfasi.dart';
import '../screens/dersler/KonuListesiSayfasi.dart';
import '../screens/bildirimler/BildirimlerEkrani.dart';
import '../screens/dersler/NotlarSayfasi.dart';

//Navigasyon Haritası
class AppRoutes {
  // ROTA İSİMLERİ (Sabitler)
  // Yazım hatası yapmamak için isimleri değişkene atıyoruz.
  //'/ayarlar' yazmak yerine AppRoutes.ayarlar
  static const String tanitim = '/';
  static const String giris = '/giris';
  static const String kayit = '/kayit';
  static const String anaSayfa = '/anaSayfa';
  static const String profil = '/profil';
  static const String ayarlar = '/ayarlar';
  static const String plan = '/plan';
  static const String takvim = '/takvim';
  static const String pomodoro = '/pomodoro';
  static const String aliskanliklar = '/aliskanliklar';
  static const String konuListesi = '/konuListesi';
  static const String bildirimler = '/bildirimler';
  static const String notlar = '/notlar';

  // ROTA HARİTASI
  // Hangi ismin hangi sayfayı açacağını burada belirliyoruz.
  //profil adresi gelirse, git ve ProfilSayfasi widget'ını ekrana çiz.
  static Map<String, WidgetBuilder> get routes => {
    tanitim: (context) => const TanitimEkrani(),
    giris: (context) => const GirisEkrani(),
    kayit: (context) => const KayitEkrani(),
    anaSayfa: (context) => const AnaSayfa(),
    profil: (context) => const ProfilSayfasi(),
    ayarlar: (context) => const AyarlarEkrani(),
    plan: (context) => const PlanSayfasi(),
    takvim: (context) => const TakvimSayfasi(),
    pomodoro: (context) => const PomodoroSayfasi(),
    aliskanliklar: (context) => const AliskanliklarSayfasi(),
    konuListesi: (context) => const KonuListesiSayfasi(),
    bildirimler: (context) => const BildirimlerEkrani(),
    notlar: (context) => const NotlarSayfasi(),
  };
}