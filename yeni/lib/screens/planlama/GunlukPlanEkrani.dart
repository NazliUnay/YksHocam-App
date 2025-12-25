import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/plan_model.dart';
import '../../services/plan_service.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../utils/yardimcilar.dart';

import '../../widgets/ortak/ortak_bilesenler.dart';
import '../../widgets/plan/gunluk_plan_header.dart';
import '../../widgets/plan/gunluk_plan_karti.dart';

class GunlukPlanEkrani extends StatefulWidget {
  final DateTime secilenTarih;
  const GunlukPlanEkrani({super.key, required this.secilenTarih});

  @override
  State<GunlukPlanEkrani> createState() => _GunlukPlanEkraniState();
}

class _GunlukPlanEkraniState extends State<GunlukPlanEkrani> {
  final PlanService _apiService = PlanService();
  List<PlanModel> _gorevler = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    setState(() => _isLoading = true);
    var gelenVeri = await _apiService.getPlanlar(widget.secilenTarih);
    if (mounted) {
      setState(() {
        _gorevler = gelenVeri;
        _isLoading = false;
      });
    }
  }

  // --- SAAT SEÇİCİ ---
  void _modernSaatSecici(BuildContext context, TextEditingController controller, Function onUpdate) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
                  const Text("Saat Seç", style: TextStyle(fontWeight: FontWeight.bold, color: mainPurple)),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        final now = DateTime.now();
                        controller.text = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                      }
                      onUpdate(); // Dialogu güncelle
                      Navigator.pop(context);
                    },
                    child: const Text("Tamam", style: TextStyle(fontWeight: FontWeight.bold, color: mainPurple)),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: CupertinoDatePicker(//kaydrımalı çark
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDate) {
                    final String formattedTime = "${newDate.hour.toString().padLeft(2, '0')}:${newDate.minute.toString().padLeft(2, '0')}";
                    controller.text = formattedTime;
                    onUpdate(); // Seçildikçe arkadaki TextField'ı güncelle
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- YENİ GÖREV EKLEME ---
  void _yeniGorevEkle() {
    final TextEditingController adController = TextEditingController();
    final TextEditingController saatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Yeni Görev", style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: adController,
                    decoration: customInputDecoration(label: "Görev Adı", icon: Icons.task)
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: saatController,
                  readOnly: true,
                  onTap: () => _modernSaatSecici(context, saatController, () => setDialogState(() {})),
                  decoration: customInputDecoration(label: "Saat Seç", icon: Icons.timer_outlined),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: mainPurple),
                onPressed: () async {
                  // Değerleri al ve temizle
                  final String finalAd = adController.text.trim();
                  final String finalSaat = saatController.text.trim();

                  // KONTROL: Eğer boşsa ekleme yapma ve kullanıcıya bildir
                  if (finalAd.isEmpty || finalSaat.isEmpty) {
                    showCustomSnackBar(context, "Lütfen görev adı ve saat girin!", isError: true);
                    return;
                  }

                  // Önce Dialog'u Kapat
                  Navigator.pop(context);

                  // Model oluştur
                  PlanModel yeni = PlanModel(
                    baslik: finalAd,
                    saat: finalSaat,
                    tarih: widget.secilenTarih.toIso8601String(),
                    tamamlandiMi: false,
                  );

                  // Servisi Çağır (Ekleme Tetikleme)
                  await _apiService.planEkle(yeni);

                  // Listeyi Yenile
                  _fetchPlans();
                },
                child: const Text("Ekle", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- DÜZENLEME ---
  void _gorevDuzenle(PlanModel plan) {
    final TextEditingController adController = TextEditingController(text: plan.baslik);
    final TextEditingController saatController = TextEditingController(text: plan.saat);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Görevi Düzenle", style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: adController, decoration: customInputDecoration(label: "Görev Adı", icon: Icons.edit)),
                const SizedBox(height: 15),
                TextField(
                  controller: saatController,
                  readOnly: true,
                  onTap: () => _modernSaatSecici(context, saatController, () => setDialogState(() {})),
                  decoration: customInputDecoration(label: "Saat Seç", icon: Icons.timer_outlined),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: mainPurple),
                onPressed: () async {
                  if (adController.text.isNotEmpty && saatController.text.isNotEmpty) {
                    Navigator.pop(context);
                    plan.baslik = adController.text;
                    plan.saat = saatController.text;
                    await _apiService.planGuncelle(plan);
                    _fetchPlans();
                  }
                },
                child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  GunlukPlanHeader(tarih: widget.secilenTarih),
                  Expanded(
                    child: _isLoading
                        ? buildLoadingWidget()
                        : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _gorevler.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final plan = _gorevler[index];
                        return GestureDetector(
                          onDoubleTap: () => _gorevDuzenle(plan),
                          child: GunlukPlanKarti(
                            plan: plan,
                            onTap: () async {
                              setState(() => plan.tamamlandiMi = !plan.tamamlandiMi);
                              await _apiService.planGuncelle(plan);
                            },
                            onLongPress: () async {
                              await _apiService.planSil(plan.id!);
                              _fetchPlans();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        onPressed: _yeniGorevEkle,
                        backgroundColor: mainPurple,
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildSideDecorator(),
          ],
        ),
      ),
    );
  }
}