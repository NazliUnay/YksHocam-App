import 'dart:convert';
import '../models/Aliskanlik_model.dart';
import 'base_service.dart';

class AliskanlikService extends BaseService {

  // Kullanıcının tüm alışkanlıklarını listele
  Future<List<AliskanlikModel>> getAliskanliklar() async {
    final userId = await getUserId();
    if (userId == null) return [];

    final response = await getRequest('Aliskanliklar/GetByUserId/$userId');

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AliskanlikModel.fromJson(json)).toList();
    }
    return [];
  }

  // Belirli bir ay içindeki tamamlanan günleri getirir
  Future<Set<int>> getTamamlananGunler(int aliskanlikId, int yil, int ay) async {
    final response = await getRequest('Aliskanliklar/GetirGunler/$aliskanlikId/$yil/$ay');

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => int.parse(e.toString())).toSet();
    }
    return {};
  }

  // Yeni alışkanlık ekle
  Future<bool> aliskanlikEkle(String isim) async {
    final userId = await getUserId();
    if (userId == null) return false;

    final response = await postRequest('Aliskanliklar/Ekle', {
      "KullaniciId": userId,
      "Baslik": isim.trim(),
      "OlusturmaTarihi": DateTime.now().toIso8601String(),
    });

    return response != null && (response.statusCode == 200 || response.statusCode == 201);
  }

  // Takvimde bir günü işaretle veya işareti kaldır
  Future<bool> gunIsaretle(int aliskanlikId, DateTime tarih) async {
    final response = await postRequest('Aliskanliklar/GunIsaretle', {
      "AliskanlikId": aliskanlikId,
      "Tarih": tarih.toIso8601String(),
    });
    return response != null && response.statusCode == 200;
  }

  // Alışkanlığı sil
  Future<bool> aliskanlikSil(int id) async {
    return await deleteRequest('Aliskanliklar/Sil/$id');
  }
}