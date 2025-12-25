// lib/data/ders_verileri.dart
class DersVerileri {
  // TYT: Herkes için ortak dersler
  static const List<String> tytDersleri = [
    "Türkçe", "Matematik", "Geometri", "Tarih", "Coğrafya", "Felsefe", "Din Kültürü", "Fizik", "Kimya", "Biyoloji"
  ];

  // AYT: Alana göre değişen dersler
  static const Map<String, List<String>> aytDersleri = {
    "Sayısal": ["Matematik", "Geometri", "Fizik", "Kimya", "Biyoloji"],
    "Eşit Ağırlık": ["Matematik", "Geometri", "Edebiyat", "Tarih-1", "Coğrafya-1"],
    "Sözel": ["Edebiyat", "Tarih-1", "Coğrafya-1", "Tarih-2", "Coğrafya-2", "Felsefe Grubu", "Din Kültürü"],
    "Dil": ["YDT (İngilizce)", "Kelime Bilgisi", "Dilbilgisi", "Okuma Parçası"]
  };

  // Yardımcı Fonksiyon: Alana ve Tipe göre listeyi döndürür
  static List<String> getDersler(String tip, String alan) {
    if (tip == "TYT") {
      return tytDersleri;
    } else {
      // Eğer alan bulunamazsa varsayılan olarak Sayısal döndür
      return aytDersleri[alan] ?? aytDersleri["Sayısal"]!;
    }
  }
  //static olarak tanımladım
  // bu verilere ulaşmak için sınıftan yeni bir nesne üretmeden erişiriz
}