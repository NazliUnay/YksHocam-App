import 'package:flutter/material.dart';
import 'GirisEkrani.dart';
import '../../services/auth_service.dart';
import '../../theme/renkler.dart';           // mainPurple rengi için
import '../../theme/stiller.dart';           // gapH20, gapH30, headerStyle, customInputDecoration için
import '../../utils/yardimcilar.dart';       // showCustomSnackBar için
import '../../widgets/ortak/ortak_bilesenler.dart'; // customElevatedButton, customNavigationLink, buildAppBackground için

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  // --- FORM VE KONTROLCÜLER ---
  final _formKey = GlobalKey<FormState>();//formun tum kurallarını denetlemek

  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // --- DURUM DEĞİŞKENLERİ ---
  final String _varsayilanAlan = "Sayısal";
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool _isLoading = false;

  final AuthService _apiService = AuthService();

  // --- KAYIT FONKSİYONU ---
  void _kayitOl() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);
      String varsayilanProfilUrl = "";

      bool basarili = await _apiService.register(
          _adSoyadController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _varsayilanAlan,
          varsayilanProfilUrl // Değişen değişken buraya iletildi
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (basarili) {
        showCustomSnackBar(context, "Kayıt Başarılı! Giriş yapabilirsiniz.");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const GirisEkrani())
        );
      } else {
        showCustomSnackBar(context, "Kayıt başarısız. E-posta kullanımda olabilir.", isError: true);
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (basarili) {
        showCustomSnackBar(context, "Kayıt Başarılı! Giriş yapabilirsiniz.");
        Navigator.pushReplacement(//tammaen kapat
            context,
            MaterialPageRoute(builder: (context) => const GirisEkrani())
        );
      } else {
        // API tarafından kullanıcı mevcutsa veya hata oluşursa mesaj döner
        showCustomSnackBar(context, "Kayıt başarısız. E-posta kullanımda olabilir.", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // ARKA PLAN SÜSLEMELERİ
                    ...buildAppBackground(),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacer(flex: 1),
                              // BAŞLIK [cite: 7]
                              const Text(
                                  "Kayıt Ol",
                                  textAlign: TextAlign.center,
                                  style: headerStyle
                              ),

                              gapH30,

                              // İsim Soyisim [cite: 10]
                              TextFormField(
                                controller: _adSoyadController,
                                textCapitalization: TextCapitalization.words,
                                decoration: customInputDecoration(label: "İsim Soyisim", icon: Icons.person),
                                validator: (value) => (value == null || value.isEmpty) ? "İsim alanı boş bırakılamaz" : null,
                              ),

                              gapH20,

                              // E-posta [cite: 10]
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: customInputDecoration(label: "E-posta", icon: Icons.email),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "E-posta alanı boş bırakılamaz";
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return "Geçerli bir e-posta giriniz";
                                  return null;
                                },
                              ),

                              gapH20,

                              // Şifre (Göz ikonu özelliği ile)
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _isObscure,
                                decoration: customInputDecoration(label: "Şifre", icon: Icons.lock).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: mainPurple),
                                    onPressed: () => setState(() => _isObscure = !_isObscure),
                                  ),
                                ),
                                validator: (value) => (value != null && value.length >= 6) ? null : "Şifre en az 6 karakter olmalı",
                              ),

                              gapH20,

                              // Şifre Tekrar [cite: 10]
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _isObscureConfirm,
                                decoration: customInputDecoration(label: "Şifre Tekrar", icon: Icons.lock).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscureConfirm ? Icons.visibility_off : Icons.visibility, color: mainPurple),
                                    onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                                  ),
                                ),
                                validator: (value) => (value != _passwordController.text) ? "Şifreler uyuşmuyor" : null,
                              ),

                              gapH30,

                              // Kayıt Butonu [cite: 7]
                              customElevatedButton(
                                text: "Kayıt Ol",
                                isLoading: _isLoading,
                                onPressed: _kayitOl,
                              ),

                              gapH20,

                              // Giriş Linki [cite: 8]
                              customNavigationLink(
                                text: "Hesabın var mı? ",
                                linkText: "Giriş Yap",
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const GirisEkrani())
                                  );
                                },
                              ),

                              const Spacer(flex: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}