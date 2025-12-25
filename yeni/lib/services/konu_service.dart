import 'dart:convert';
import '../models/konu_model.dart';
import 'base_service.dart';

class KonuService extends BaseService {

  // Ders konularını getir
  Future<List<KonuModel>> getKonular(String alan, String ders) async {
    final userId = await getUserId();
    if (userId == null) return [];

    // Parametreleri güvenli hale getirmek için encodeComponent kullanın
    final encodedAlan = Uri.encodeComponent(alan);
    final encodedDers = Uri.encodeComponent(ders);

    final response = await getRequest('Konular/GetByDers/$userId?alan=$encodedAlan&ders=$encodedDers');

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => KonuModel.fromJson(e)).toList();
    }
    return [];
  }
  // Konu durumunu (tamamlandı/tamamlanmadı) güncelle
  Future<bool> konuDurumGuncelle(int konuId, bool durum) async {
    final userId = await getUserId();
    if (userId == null) return false;

    final response = await postRequest('Konular/DurumGuncelle', {
      "KonuId": konuId,
      "KullaniciId": userId,
      "TamamlandiMi": durum
    });

    return response != null && response.statusCode == 200;
  }

  // Profil sayfasındaki istatistikler
  Future<Map<String, String>> getIstatistikler() async {
    final userId = await getUserId();
    if (userId == null) return {"calisma": "0 saat", "konu": "0 konu"};

    final response = await getRequest('Kullanicilar/Istatistikler/$userId');

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return {
        "calisma": data['calisma']?.toString() ?? "0 saat",
        "konu": data['konu']?.toString() ?? "0 konu",
      };
    }

    return {"calisma": "0 saat", "konu": "0 konu"};
  }
}