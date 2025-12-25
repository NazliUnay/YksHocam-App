class PlanModel {
  int? id;
  String baslik;
  String saat;
  bool tamamlandiMi;
  String tarih;

  PlanModel({
    this.id,
    required this.baslik,
    required this.saat,
    this.tamamlandiMi = false,
    required this.tarih,
  });

  // API'den veri çekerken (C#'tan gelen küçük harf json key'leri)
  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['planId'],
      baslik: json['baslik'] ?? "",
      saat: json['saat'] ?? "",
      tamamlandiMi: json['durum'] ?? false,
      tarih: json['tarih'] ?? DateTime.now().toIso8601String(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "PlanId": id ?? 0,
      "Baslik": baslik,
      "Saat": saat,
      "Durum": tamamlandiMi,
      "Tarih": tarih,
    };
  }
}