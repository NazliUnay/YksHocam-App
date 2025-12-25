import 'package:flutter/material.dart';
class TarihVerileri {
  static const List<String> aylar = [
    "", "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
    "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
  ];
  //liste sıfırdan başladığı için
  // ocağa erşirken 1 ile erişmek için ilk elemanı boş yaptık

  static const List<String> gunler = [
    "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"
  ];
}

// Extension sayesinde DateTime nesneleri üzerinden direkt ay ismine ulaşabilir
//DateTime sınıfına yeni yetenekler kazandıracak.
extension DateTimeTurkish on DateTime {
  String get ayIsmi => TarihVerileri.aylar[this.month];
  String get gunIsmi => TarihVerileri.gunler[this.weekday - 1];
  //liste indeksi sıfırdan başladığı için ptesiye ulaşmak için -1
}