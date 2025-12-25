import 'package:flutter/material.dart';
import 'AliskanlikDetaySayfasi.dart';
import '../../services/aliskanlik_service.dart';
import '../../models/Aliskanlik_model.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';
import '../../widgets/aliskanliklar/aliskanlik_karti.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';

class AliskanliklarSayfasi extends StatefulWidget {
  const AliskanliklarSayfasi({super.key});

  @override
  State<AliskanliklarSayfasi> createState() => _AliskanliklarSayfasiState();
}

class _AliskanliklarSayfasiState extends State<AliskanliklarSayfasi> {
  final AliskanlikService _aliskanlikService = AliskanlikService();
  List<AliskanlikModel> _aliskanliklar = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  // --- API'DEN VERİLERİ ÇEKME ---
  Future<void> _verileriGetir() async {
    setState(() => _isLoading = true);
    try {
      // Servisindeki gerçek metodu çağırdık
      var gelen = await _aliskanlikService.getAliskanliklar();
      if (mounted) {
        setState(() {
          _aliskanliklar = gelen;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint("Veri getirme hatası: $e");
    }
  }

  void _silOnay(int id, String isim) {
    showCustomDialog(
      context: context,
      title: "Alışkanlığı Sil",
      content: "'$isim' alışkanlığını silmek istediğine emin misin?",
      positiveBtnText: "Sil",
      onPositivePressed: () async {
        bool sonuc = await _aliskanlikService.aliskanlikSil(id);
        if (mounted) { //hayatta mı
          if (sonuc) {
            showCustomSnackBar(context, "Alışkanlık silindi.");
            _verileriGetir();
          } else {
            showCustomSnackBar(context, "Silme işlemi başarısız.", isError: true);
          }
        }
      },
    );
  }

  void _showAddDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yeni Alışkanlık", style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: customInputDecoration(label: "Örn: Kitap Okuma", icon: Icons.edit),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: mainPurple),
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                // Ekleme metodunu çağırdık
                bool sonuc = await _aliskanlikService.aliskanlikEkle(controller.text.trim());
                if (mounted) {
                  if (sonuc) {
                    Navigator.pop(context);
                    _verileriGetir(); // Listeyi hemen tazele
                  } else {
                    showCustomSnackBar(context, "Ekleme başarısız.", isError: true);
                  }
                }
              }
            },
            child: const Text("Ekle", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(//çentik vs koruma
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: mainPurple),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Alışkanlıklar",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: "Serif"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            gapH20,
            Expanded(
              child: _isLoading
                  ? buildLoadingWidget()
                  : _aliskanliklar.isEmpty
                  ? buildEmptyState("Henüz alışkanlık eklemedin.") // Boş liste kontrolü
                  : Row(
                children: [
                  Expanded(
                    child: ListView.separated(//mesafe
                      padding: const EdgeInsets.all(30),
                      itemCount: _aliskanliklar.length,
                      separatorBuilder: (c, i) => gapH20,//contex,index
                      itemBuilder: (context, index) {//aşçı gibi
                        final item = _aliskanliklar[index];
                        return GestureDetector(//dokunma gibi fiziksel hareketler
                          // Model üzerinden verilere güvenli erişim
                          onLongPress: () => _silOnay(item.id!, item.baslik),
                          child: AliskanlikKarti(
                            isim: item.baslik,
                            icon: Icons.star_rounded,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AliskanlikDetaySayfasi(
                                      habitId: item.id!,
                                      habitName: item.baslik,
                                  ),
                                ),
                              ).then((_) => _verileriGetir()); // Detaydan dönünce yenile
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 300,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(color: mainPurple, borderRadius: BorderRadius.circular(2)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: mainPurple,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}