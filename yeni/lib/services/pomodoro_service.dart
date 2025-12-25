import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_service.dart';

class PomodoroService extends BaseService {

  // Yeni Oturum Ekleme
  Future<bool> kaydetPomodoro({
    required String calisilanKonu,
    required int sure,
    required DateTime tarih
  }) async {
    final kullaniciId = await getUserId();
    if (kullaniciId == null) return false;

    final response = await postRequest('Pomodoro/Ekle', {
      "KullaniciId": kullaniciId,
      "CalisilanKonu": calisilanKonu,
      "SureDakika": sure,
      "Tarih": tarih.toIso8601String(),
    });

    return response != null &&
        (response.statusCode == 200 || response.statusCode == 201);
  }

  // Günlük Toplam Süre
  Future<int> getBugunToplamSure() async {
    final userId = await getUserId();
    if (userId == null) return 0;

    final response = await getRequest('Pomodoro/GunlukOzet/$userId');

    if (response != null && response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['toplamDakika'] ?? 0;
    }
    return 0;
  }

  // Sadece Bugünkü Geçmişi Getirme
  Future<List<dynamic>> getBugunPomodoroGecmisi() async {
    final userId = await getUserId();
    if (userId == null) return [];

    final response = await getRequest('Pomodoro/GetTodayByUserId/$userId');
    return (response != null && response.statusCode == 200) ? jsonDecode(
        response.body) : [];
  }

  // Tüm Geçmişi Getirme
  Future<List<dynamic>> getPomodoroGecmisi() async {
    final userId = await getUserId();
    if (userId == null) return [];

    final response = await getRequest('Pomodoro/GetByUserId/$userId');
    return (response != null && response.statusCode == 200) ? jsonDecode(
        response.body) : [];
  }

  // Oturum Silme
  Future<bool> silPomodoro(int oturumId) async {
    return await deleteRequest('Pomodoro/Sil/$oturumId');
  }
}