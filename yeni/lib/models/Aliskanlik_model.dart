class AliskanlikModel {
  final int? id;//null olabilir
  final String baslik;
  final int kullaniciId;
  //final oldukları için sonradan değişmez
  //runtime

  AliskanlikModel({
    this.id,
    required this.baslik, //boş geçilemez
    required this.kullaniciId,
  });

  factory AliskanlikModel.fromJson(Map<String, dynamic> json) {
    return AliskanlikModel(
      // Backend 'AliskanlikId' veya 'id' olarak dönebilir, ikisini de kontrol ediyoruz
      id: json['aliskanlikId'] ?? json['id'] ?? json['AliskanlikId'],
      baslik: json['baslik'] ?? json['Baslik'] ?? "",
      kullaniciId: json['kullaniciId'] ?? json['KullaniciId'] ?? 0,
    );
  }


  Map<String, dynamic> toJson() { //sınıfın içindekii veriyi mape dönüştürüyoruz
    return {
      "AliskanlikId": id,
      "Baslik": baslik,
      "KullaniciId": kullaniciId,
    };
  //kullanma nedenimiiz
  // * Veritabanına yeni bir kayıt eklerken.
    // *Bir API'ye POST isteğiyle veri gönderirken.
  }
}

///toJson (Veri Gönderirken)