import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';

class SifreUnuttumDialog extends StatefulWidget {
  const SifreUnuttumDialog({super.key});

  @override
  State<SifreUnuttumDialog> createState() => _SifreUnuttumDialogState();
}

class _SifreUnuttumDialogState extends State<SifreUnuttumDialog> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _gonder() async {
    String mail = _emailController.text.trim();

    // Basit Kontroller
    if (mail.isEmpty) {
      showCustomSnackBar(context, "Lütfen e-posta adresinizi giriniz.", isError: true);
      return;
    }
    if (!mail.contains("@") || !mail.contains(".")) {
      showCustomSnackBar(context, "Geçerli bir e-posta formatı giriniz.", isError: true);
      return;
    }

    // API İsteği
    setState(() => _isSending = true);

    bool sonuc = await _authService.sifremiUnuttum(mail);

    if (!mounted) return;
    setState(() => _isSending = false);
    Navigator.pop(context);

    // Sonuç Bildirimi
    if (sonuc) {
      showCustomSnackBar(context, "Bağlantı e-posta adresinize gönderildi!");
    } else {
      showCustomSnackBar(context, "Sistemde kayıtlı e-posta bulunamadı.", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Şifremi Unuttum",
        style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Sıfırlama bağlantısı için kayıtlı e-posta adresinizi giriniz."),
          gapH20,
          TextFormField(
            controller: _emailController,
            decoration: customInputDecoration(label: "E-posta", icon: Icons.email),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSending ? null : () => Navigator.pop(context),
          child: const Text("İptal", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: mainPurple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: _isSending ? null : _gonder,
          child: _isSending
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : const Text("Gönder", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}