import 'dart:convert';
import '../models/onemli_gun_model.dart';
import 'base_service.dart';

class OnemliGunService extends BaseService {
  // Belirli bir ayın önemli günlerini getir
  Future<List<OnemliGunModel>> getAyinOnemliGunleri(int kullaniciId, DateTime tarih) async {
    // Endpoint'i doğrudan string olarak veriyoruz
    final response = await getRequest('OnemliGunler/Getir/$kullaniciId/${tarih.year}/${tarih.month}');

    if (response != null && response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => OnemliGunModel.fromJson(e)).toList();
    }
    return [];
  }

  // Yeni önemli gün ekle
  Future<bool> onemliGunEkle(OnemliGunModel model) async {
    final response = await postRequest('OnemliGunler/Ekle', model.toJson());
    return response != null && response.statusCode == 200;
  }

  // Önemli günü sil
  Future<bool> onemliGunSil(int id) async {
    return await deleteRequest('OnemliGunler/Sil/$id');
  }
}