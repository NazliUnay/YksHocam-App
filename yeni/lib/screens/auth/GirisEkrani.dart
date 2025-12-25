import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'KayitEkrani.dart';
import '../anasayfa/AnaSayfa.dart';
import '../../services/auth_service.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';
import '../../widgets/ortak/sifre_unuttum_dialog.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  // --- DURUM DEĞİŞKENLERİ ---
  bool _isObscure = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // --- KONTROLCÜLER VE SERVİSLER ---
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _beniHatirlaBilgileriniGetir();
  }

  // Hafızadaki bilgileri getir
  void _beniHatirlaBilgileriniGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kayitliEmail = prefs.getString('email');
    String? kayitliSifre = prefs.getString('password');
    bool? beniHatirla = prefs.getBool('remember_me');

    if (beniHatirla == true && kayitliEmail != null) {
      setState(() {
        _emailController.text = kayitliEmail;
        _passwordController.text = kayitliSifre ?? "";
        _rememberMe = true;
      });
    }
  }

  // Giriş İşlemi
  void _girisYap() async {
    String email = _emailController.text.trim();
    String sifre = _passwordController.text.trim();

    if (email.isEmpty || sifre.isEmpty) {
      showCustomSnackBar(context, "Lütfen tüm alanları doldurunuz.", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool basarili = await _authService.login(email, sifre);

      if (!mounted) return;//widget lu an var mı ekranda
      setState(() => _isLoading = false);

      if (basarili) {
        // "Beni Hatırla" Kaydet/Sil
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //hard diskte var mi
        if (_rememberMe) {//kayitli mi
          await prefs.setString('email', email);
          await prefs.setString('password', sifre);
          await prefs.setBool('remember_me', true);
        } else {
          await prefs.remove('email');
          await prefs.remove('password');
          await prefs.setBool('remember_me', false);
        }

        Navigator.pushReplacement(//şu anki ekranı tamamen kapat
          context,
          MaterialPageRoute(builder: (context) => const AnaSayfa()),
        );
      } else {
        showCustomSnackBar(context, "E-posta veya şifre hatalı!", isError: true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showCustomSnackBar(context, "Bağlantı hatası: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(//üst üste
            children: [
              // ARKA PLAN SÜSLEMELERİ
              ...buildAppBackground(),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 6), // Üst boşluk

                      // BAŞLIK
                      const Text(
                        "Giriş Yap",
                        textAlign: TextAlign.center,
                        style: headerStyle,
                      ),

                      const Spacer(flex: 1),

                      // E-POSTA GİRİŞ
                      TextFormField(
                        controller: _emailController,
                        decoration: customInputDecoration(label: "E-posta", icon: Icons.email),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      gapH20,

                      // ŞİFRE GİRİŞ
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,//görünmeyi engellemek
                        decoration: customInputDecoration(label: "Şifre", icon: Icons.lock).copyWith(
                          suffixIcon: IconButton(//en sağda
                            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: mainPurple),
                            onPressed: () => setState(() => _isObscure = !_isObscure),
                          ),
                        ),
                      ),

                      gapH10,

                      // ALT SEÇENEKLER (Beni Hatırla & Şifremi Unuttum)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Beni Hatırla
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: mainPurple,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                onChanged: (v) => setState(() => _rememberMe = v!),
                              ),
                              const Text("Beni Hatırla",
                                  style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),

                          // Şifremi Unuttum
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const SifreUnuttumDialog(),
                              );
                            },
                            child: const Text("Şifremi Unuttum",
                                style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        ],
                      ),

                      gapH20,

                      // GİRİŞ BUTONU
                      customElevatedButton(
                        text: "Giriş",
                        isLoading: _isLoading,
                        onPressed: _girisYap,
                      ),

                      gapH20,

                      // KAYIT OL LİNKİ
                      customNavigationLink(
                        text: "Hesabın yok mu? ",
                        linkText: "Kayıt Ol",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const KayitEkrani())
                          );
                        },
                      ),

                      const Spacer(flex: 6), // Alt boşluk
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}