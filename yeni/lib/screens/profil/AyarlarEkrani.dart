import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';

import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';

import '../../widgets/ayarlar/profil_resmi_bolumu.dart';
import '../../widgets/ayarlar/ayar_input_satiri.dart';
import '../../widgets/ayarlar/alan_secici_dropdown.dart';

class AyarlarEkrani extends StatefulWidget {
  const AyarlarEkrani({super.key});

  @override
  State<AyarlarEkrani> createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends State<AyarlarEkrani> {
  final AuthService _apiService = AuthService();

  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? _userId;
  String _secilenAlan = "Sayısal";
  final List<String> _alanlar = ["Sayısal", "Eşit Ağırlık", "Sözel", "Dil"];
  bool _isLoading = false;
  File? _secilenDosya;

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  void _verileriGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
      _adSoyadController.text = prefs.getString('adSoyad') ?? "";
      _emailController.text = prefs.getString('email') ?? "";
      _sifreController.text = "******";
      _secilenAlan = prefs.getString('alan') ?? "Sayısal";

      String? localPath = prefs.getString('local_resim_yolu');
      if (localPath != null && localPath.isNotEmpty) {
        File dosya = File(localPath);
        if (dosya.existsSync()) {
          _secilenDosya = dosya;
        }
      }
    });
  }

  void _fotografDegistir() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? secilenXFile = await picker.pickImage(source: ImageSource.gallery);

      if (secilenXFile != null) {
        setState(() {
          _secilenDosya = File(secilenXFile.path);
        });
        showCustomSnackBar(context, "Yeni fotoğraf seçildi.");
      }
    } catch (e) {
      debugPrint("Resim hatası: $e");
    }
  }

  void _fotografiBuyut() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: _secilenDosya != null
                    ? FileImage(_secilenDosya!) as ImageProvider
                    : const AssetImage('assets/images/kedi_profil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  void _kaydet() async {
    if (_userId == null) return;

    setState(() => _isLoading = true);

    bool sonuc = await _apiService.profilGuncelle(
        _userId!,
        _adSoyadController.text.trim(),
        _emailController.text.trim(),
        _secilenAlan,
        _secilenDosya
    );

    setState(() => _isLoading = false);

    if (sonuc) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('adSoyad', _adSoyadController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('alan', _secilenAlan);

      if (_secilenDosya != null) {
        // Profil sayfası burayı okuyarak resmi güncelleyecek
        await prefs.setString('local_resim_yolu', _secilenDosya!.path);
      }

      if (mounted) {
        showCustomSnackBar(context, "Bilgiler Güncellendi!");

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } else {
      if (mounted) {
        showCustomSnackBar(context, "Güncelleme başarısız oldu.", isError: true);
      }
    }
  } // _kaydet sonu (buradaki parantez eksikti)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ayarlar",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            gapH10,
            ProfilResmiBolumu(
              secilenDosya: _secilenDosya,
              onResimDegistir: _fotografDegistir,
              onResimBuyut: _fotografiBuyut,
            ),
            const SizedBox(height: 15),
            Text(
              _adSoyadController.text.isEmpty ? "KULLANICI" : _adSoyadController.text.toUpperCase(),
              style: const TextStyle(
                color: mainPurple,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            AyarInputSatiri(
                controller: _adSoyadController,
                icon: Icons.person,
                hint: "Ad Soyad"
            ),
            gapH20,
            AyarInputSatiri(
                controller: _sifreController,
                icon: Icons.lock,
                hint: "Şifre",
                isPassword: true
            ),
            gapH20,
            AyarInputSatiri(
                controller: _emailController,
                icon: Icons.email,
                hint: "Email"
            ),
            gapH20,
            AlanSeciciDropdown(
                secilenAlan: _secilenAlan,
                alanlar: _alanlar,
                onChanged: (newValue) => setState(() => _secilenAlan = newValue!)
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: customElevatedButton(
                text: "Kaydet",
                isLoading: _isLoading,
                onPressed: _kaydet,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}