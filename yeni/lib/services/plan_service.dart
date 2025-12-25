import 'dart:convert';
import '../models/plan_model.dart';
import 'base_service.dart';

class PlanService extends BaseService {

  // Günlük planları getir
  Future<List<PlanModel>> getPlanlar(DateTime tarih) async {
    final userId = await getUserId();
    if (userId == null) return [];

    // Sorgu parametresini string içine doğrudan ekliyoruz
    final formattedDate = tarih.toIso8601String();
    final response = await getRequest('Planlar/GetByDate/$userId?tarih=$formattedDate');
    print("API Yanıtı: ${response?.body}");
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PlanModel.fromJson(e)).toList();
    }
    return [];
  }

  // Yeni plan ekle
  Future<bool> planEkle(PlanModel plan) async {
    final userId = await getUserId();
    if (userId == null) return false;

    var bodyData = plan.toJson();
    bodyData['KullaniciId'] = userId;

    final response = await postRequest('Planlar/Ekle', bodyData);
    return response != null && response.statusCode == 200;
  }

  // Plan güncelle (PUT isteği)
  Future<bool> planGuncelle(PlanModel plan) async {
    final userId = await getUserId();
    if (userId == null) return false;

    var body = plan.toJson();
    body['KullaniciId'] = userId;

    final response = await putRequest('Planlar/Guncelle', body);
    return response != null && response.statusCode == 200;
  }

  // Plan sil
  Future<bool> planSil(int id) async {
    return await deleteRequest('Planlar/Sil/$id');
  }

  // Sınav tarihini getir
  Future<Map<String, dynamic>?> getSinavTarihi() async {
    final response = await getRequest('Kullanicilar/CanliSinavTarihi');
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}