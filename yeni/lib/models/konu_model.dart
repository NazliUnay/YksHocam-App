class KonuModel {
  int? id;
  String ad;
  String alan;
  String ders;
  bool tamamlandiMi;

  KonuModel({
    this.id,
    required this.ad,
    required this.alan,
    required this.ders,
    this.tamamlandiMi = false,
  });
  Map<String, dynamic> toJson() {
    return {
      "KonuAdi": ad,
      "DersAdi": ders,
      "DersTip": alan,
      "TamamlandiMi": tamamlandiMi,
    };
  }
  //fromJson (Veri Okurken)

  factory KonuModel.fromJson(Map<String, dynamic> json) {
    return KonuModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      ad: json['ad']?.toString() ?? "",
      alan: "",
      ders: "",
      tamamlandiMi: json['tamamlandiMi'] == true,
    );
//fromJson (Veri Alırken)
}}