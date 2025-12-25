import 'dart:convert';
import '../models/not_model.dart';
import 'base_service.dart';

class NotService extends BaseService {

  // Belirli bir kategorideki notları getir
  Future<List<NotModel>> getNotlar(String kategori) async {
    final userId = await getUserId();
    if (userId == null) return [];

    // Parametreyi doğrudan string içine gömerek gönderiyoruz
    final response = await getRequest('Notlar/GetByKategori/$userId?kategori=$kategori');

    if (response != null && response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => NotModel.fromJson(e)).toList();
    }
    return [];
  }

  // Yeni not ekle
  Future<bool> notEkle(NotModel not) async {
    final userId = await getUserId();
    if (userId == null) return false;

    var bodyData = not.toJson();
    bodyData['KullaniciId'] = userId;

    final response = await postRequest('Notlar/Ekle', bodyData);
    return response != null && response.statusCode == 200;
  }

  // Tek not sil
  Future<bool> notSil(int id) async {
    return await deleteRequest('Notlar/Sil/$id');
  }

  // Çoklu not sil (Liste halinde ID gönderimi)
  Future<bool> topluSil(List<int> idListesi) async {
    // Toplu silme işlemi backend'de POST olarak tanımlı olduğu için postRequest kullanıyoruz
    final response = await postRequest('Notlar/TopluSil', {
      "ids": idListesi
    });

    return response != null && response.statusCode == 200;
  }
}