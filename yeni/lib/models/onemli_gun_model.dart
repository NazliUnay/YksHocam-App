class OnemliGunModel {
  int? id;
  int? kullaniciId;
  String baslik;
  DateTime tarih;

  OnemliGunModel({
    this.id,
    this.kullaniciId,
    required this.baslik,
    required this.tarih,
  });

  factory OnemliGunModel.fromJson(Map<String, dynamic> json) {
    return OnemliGunModel(
      id: json['onemliGunId'] ?? json['OnemliGunId'],
      kullaniciId: json['kullaniciId'] ?? json['KullaniciId'],
      baslik: json['baslik'] ?? json['Baslik'] ?? "",
      tarih: DateTime.parse(json['tarih'] ?? json['Tarih']),
      //parse sayesinde matematiksel işlemler yapılabilir
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "OnemliGunId": id ?? 0,
      "KullaniciId": kullaniciId,
      "Baslik": baslik,
      "Tarih": tarih.toIso8601String(),
    };
  }
}