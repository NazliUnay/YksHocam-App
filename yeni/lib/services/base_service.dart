import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

abstract class BaseService {//soyut

  // Ortak Kullanıcı ID Çekme
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Ortak GET İsteği
  Future<http.Response?> getRequest(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
      final response = await http.get(url, headers: ApiConfig.headers);
      return response;
    } catch (e) {
      print("GET Hatası ($endpoint): $e");
      return null;
    }
  }

  // Ortak POST İsteği
  Future<http.Response?> postRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
      final response = await http.post(
          url,
          headers: ApiConfig.headers,
          body: jsonEncode(body)
      );
      return response;
    } catch (e) {
      print("POST Hatası ($endpoint): $e");
      return null;
    }
  }

  // Ortak PUT İsteği (Okundu yap işlemi için gerekli)
  Future<http.Response?> putRequest(String endpoint, [Map<String, dynamic>? body]) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
      final response = await http.put(
          url,
          headers: ApiConfig.headers,
          body: body != null ? jsonEncode(body) : null
      );
      return response;
    } catch (e) {
      print("PUT Hatası ($endpoint): $e");
      return null;
    }
  }

  // Ortak DELETE İsteği
  Future<bool> deleteRequest(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
      final response = await http.delete(url, headers: ApiConfig.headers);
      return response.statusCode == 200;
    } catch (e) {
      print("DELETE Hatası ($endpoint): $e");
      return false;
    }
  }
}