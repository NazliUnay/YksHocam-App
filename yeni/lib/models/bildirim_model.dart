class BildirimModel {
  final int id;
  final String baslik;
  final String zaman;

  BildirimModel({
    required this.id,
    required this.baslik,
    required this.zaman,
  });

  factory BildirimModel.fromJson(Map<String, dynamic> json) {
    return BildirimModel(
      id: json['bildirimId'],
      baslik: json['mesaj'] ?? "Başlıksız Bildirim",
      zaman: json['tarih'] != null      // Tarihi basitçe formatlayıp alıyoruz
          ? json['tarih'].toString().substring(0, 16).replaceAll("T", " ")
          : "",
      // Kırpma (substring): İlk 16 karakteri alır.
      // Yani saniyeleri ve milisaniyeleri atar,
      // sadece 2023-12-25T14:30 kısmını tutar.
    );
  }
  //fromJson (Veri Alırken)
}