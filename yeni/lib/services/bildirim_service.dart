import 'dart:convert';
import '../models/bildirim_model.dart';
import 'base_service.dart';

class BildirimService extends BaseService {

  // Bildirimleri Listele
  Future<List<BildirimModel>> getBildirimler() async {
    // BaseService'den gelen getUserId fonksiyonunu kullanıyoruz
    final userId = await getUserId();
    if (userId == null) return [];

    // BaseService'den gelen getRequest fonksiyonu
    final response = await getRequest('Bildirimler/GetByUserId/$userId');

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BildirimModel.fromJson(json)).toList();
    }
    return [];
  }

  // Yeni Bildirim Ekle
  Future<bool> bildirimEkle(String mesaj) async {
    final userId = await getUserId();
    if (userId == null) return false;

    final response = await postRequest('Bildirimler/Ekle', {
      "KullaniciId": userId,
      "Mesaj": mesaj
    });

    return response != null && response.statusCode == 200;
  }

  // Tek Bir Bildirimi Sil
  Future<bool> bildirimSil(int bildirimId) async {
    // BaseService'deki deleteRequest metodunu kullanıyoruz
    return await deleteRequest('Bildirimler/Sil/$bildirimId');
  }

  // Tüm Bildirimleri Sil
  Future<bool> tumBildirimleriSil() async {
    final userId = await getUserId();
    if (userId == null) return false;

    return await deleteRequest('Bildirimler/TumuSil/$userId');
  }

  // Bildirimi Okundu İşaretle
  Future<bool> bildirimOkunduYap(int bildirimId) async {
    final response = await putRequest('Bildirimler/OkunduYap/$bildirimId');
    return response != null && response.statusCode == 200;
  }
}