class NotModel {
  int? id;
  String icerik;
  String ders;
  String alan;
  String kategori;
  bool seciliMi;

  NotModel({
    this.id,
    required this.icerik,
    required this.ders,
    required this.alan,
    required this.kategori,
    this.seciliMi = false,
  });

  factory NotModel.fromJson(Map<String, dynamic> json) {
    return NotModel(
      id: json['id'] ?? json['notId'],
      icerik: json['icerik'] ?? "",
      ders: json['baslik'] ?? "Genel",
      alan: json['alan'] ?? "TYT",
      kategori: json['kategori'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Baslik": ders,
      "Icerik": icerik,
      "Alan": alan,
      "Kategori": kategori,
    };
  }
}