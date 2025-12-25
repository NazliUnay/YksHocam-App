import 'package:flutter/material.dart';
import '../../services/bildirim_service.dart';
import '../../models/bildirim_model.dart';
import '../../theme/renkler.dart';           // mainPurple
import '../../theme/stiller.dart';           // gapH10
import '../../utils/yardimcilar.dart';       // showCustomDialog, showCustomSnackBar
import '../../widgets/ortak/ortak_bilesenler.dart'; // customAppBar, buildLoadingWidget
import '../../widgets/bildirimler/bildirim_karti.dart';
import '../../widgets/bildirimler/bildirim_bos_durum.dart';
import '../../widgets/bildirimler/tumunu_temizle_buton.dart';

class BildirimlerEkrani extends StatefulWidget {
  const BildirimlerEkrani({super.key});

  @override
  State<BildirimlerEkrani> createState() => _BildirimlerEkraniState();
}

class _BildirimlerEkraniState extends State<BildirimlerEkrani> {
  final BildirimService _apiService = BildirimService();
  final ScrollController _scrollController = ScrollController();

  List<BildirimModel> bildirimler = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _bildirimleriYukle();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _bildirimleriYukle() async {
    List<BildirimModel> gelenVeri = await _apiService.getBildirimler();
    if (mounted) {
      setState(() {
        bildirimler = gelenVeri;
        isLoading = false;
      });
    }
  }

  void _bildirimSil(int index) async {
    int silinecekId = bildirimler[index].id;
    setState(() {
      bildirimler.removeAt(index);
    });
    await _apiService.bildirimSil(silinecekId);
  }

  void _tumunuTemizle() {
    showCustomDialog(
      context: context,
      title: "Bildirimleri Temizle",
      content: "Tüm bildirimleriniz kalıcı olarak silinecektir. Onaylıyor musunuz?",
      positiveBtnText: "Evet, Sil",
      onPositivePressed: () async {
        setState(() => bildirimler.clear());
        await _apiService.tumBildirimleriSil();
        if (mounted) {
          showCustomSnackBar(context, "Bildirim kutusu temizlendi.");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context, "Bildirimler"),
      body: isLoading
          ? buildLoadingWidget()
          : bildirimler.isEmpty
          ? const BildirimBosDurum()
          : RawScrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        thumbColor: mainPurple,
        thickness: 5,
        radius: const Radius.circular(10),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          // Liste elemanlarına ek olarak en sona "Tümünü Temizle" butonu
          itemCount: bildirimler.length + 1,
          separatorBuilder: (context, index) => gapH10,
          itemBuilder: (context, index) {
            // Listenin son elemanı ise "Temizle" butonunu göster
            if (index == bildirimler.length) {
              return TumunuTemizleButon(
                onPressed: _tumunuTemizle,
                isPassive: false,
              );
            }

            // Değilse Bildirim Kartını göster
            return BildirimKarti(
              bildirim: bildirimler[index],
              onSil: () => _bildirimSil(index),
            );
          },
        ),
      ),
    );
  }
}