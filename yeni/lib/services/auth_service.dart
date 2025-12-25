import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
import 'base_service.dart';

class AuthService extends BaseService {

  // Giriş Yap
  Future<bool> login(String email, String password) async {
    final response = await postRequest('Kullanicilar/Giris', {
      "Email": email.trim(),
      "Sifre": password.trim(),
    });

    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Verileri saklama mantığı burada kalmalı
      if (data['userId'] != null) await prefs.setInt('userId', data['userId']);
      if (data['adSoyad'] != null) await prefs.setString('adSoyad', data['adSoyad']);
      if (data['alan'] != null) await prefs.setString('alan', data['alan']);
      if (data['profilFotoUrl'] != null) {
        await prefs.setString('profilFotoUrl', data['profilFotoUrl']);
      }
      return true;
    }
    return false;
  }

  // Kayıt Ol
  Future<bool> register(String adSoyad, String email, String password, String alan, String? profilFoto) async {
    final response = await postRequest('Kullanicilar/Ekle', {
      "AdSoyad": adSoyad,
      "Email": email,
      "Sifre": password,
      "Alan": alan,
      "ProfilFotoUrl": profilFoto
    });
    return response != null && response.statusCode == 200;
  }

  // Şifre Sıfırlama
  Future<bool> sifremiUnuttum(String email) async {
    final response = await postRequest('Kullanicilar/SifreSifirla', {
      "Email": email.trim()
    });
    return response != null && response.statusCode == 200;
  }

  // Profil Güncelleme (Multipart özel bir durumdur)
  Future<bool> profilGuncelle(int userId, String adSoyad, String email, String alan, File? resimDosyasi) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/Kullanicilar/Guncelle/$userId');
    try {
      var request = http.MultipartRequest('PUT', uri);
      request.fields['KullaniciId'] = userId.toString();
      request.fields['AdSoyad'] = adSoyad;
      request.fields['Email'] = email;
      request.fields['Alan'] = alan;

      if (resimDosyasi != null) {
        var pic = await http.MultipartFile.fromPath("ProfilFoto", resimDosyasi.path);
        request.files.add(pic);
      }

      var streamedResponse = await request.send();//parça parça
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (data['fotoUrl'] != null) {
          await prefs.setString('profilFotoUrl', data['fotoUrl']);
        }
        return true;
      }
      return false;
    } catch (e) {
      print("Profil Güncelleme Hatası: $e");
      return false;
    }
  }
}