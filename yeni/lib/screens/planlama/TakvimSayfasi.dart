import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/onemli_gun_model.dart';
import '../../utils/yardimcilar.dart';
import 'GunlukPlanEkrani.dart';

import '../../services/onemli_gun_service.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';
import '../../widgets/ortak/ortak_bilesenler.dart';
import '../../widgets/takvim/onemli_gun_karti.dart';
import '../../data/tarih_verileri.dart';

class TakvimSayfasi extends StatefulWidget {
  const TakvimSayfasi({super.key});

  @override
  State<TakvimSayfasi> createState() => _TakvimSayfasiState();
}

class _TakvimSayfasiState extends State<TakvimSayfasi> {
  final OnemliGunService _planService = OnemliGunService();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<OnemliGunModel> _ayinPlanlari = []; // Ayın tüm verilerini tutar
  bool _isLoading = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    initializeDateFormatting('tr_TR', null);
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _userId = prefs.getInt('userId');

      if (_userId == null) {
        debugPrint("HATA: SharedPreferences'dan userId alınamadı!");
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      DateTime ayinIlkGunu = DateTime(_focusedDay.year, _focusedDay.month, 1);
      var gelen = await _planService.getAyinOnemliGunleri(_userId!, ayinIlkGunu);

      if (mounted) {
        setState(() {
          _ayinPlanlari = gelen;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Veri getirme hatası: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _ayDegistir(int miktar) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + miktar, 1);
      _selectedDay = _focusedDay;
    });
    _verileriGetir();
  }

  void _etkinlikEklePaneliniAc() {
    TextEditingController controller = TextEditingController();
    showCustomBottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Önemli Gün Ekle",
              style: TextStyle(color: mainPurple, fontSize: 20, fontWeight: FontWeight.bold)),
          gapH10,
          Text(
            "${_selectedDay!.day} ${_selectedDay!.ayIsmi} ${_selectedDay!.year}",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          gapH20,
          TextField(
            controller: controller,
            autofocus: true,
            decoration: customInputDecoration(label: "Başlık Giriniz", icon: Icons.event_note),
          ),
          gapH20,
          SizedBox(
            width: double.infinity,
            child: customElevatedButton(
              text: "Ekle",
              onPressed: () async {
                String baslik = controller.text.trim();
                if (baslik.isNotEmpty && _userId != null) {
                  OnemliGunModel yeniPlan = OnemliGunModel(
                    baslik: baslik,
                    tarih: _selectedDay!,
                    kullaniciId: _userId!,
                  );
                  bool sonuc = await _planService.onemliGunEkle(yeniPlan);
                  if (mounted) {
                    if (sonuc) {
                      Navigator.pop(context);
                      showCustomSnackBar(context, "Önemli gün takvime işlendi!");
                      _verileriGetir();
                    }
                  }
                } else {
                  showCustomSnackBar(context, "Lütfen bir başlık girin.", isError: true);
                }
              },
            ),
          ),
          gapH20,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              gapH10,
              _headerOlustur(),
              gapH20,
              _takvimOlustur(),
              gapH20,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "${_selectedDay!.day} ${_selectedDay!.ayIsmi} Planları", // Seçilen güne göre dinamik başlık
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Serif"))
              ),
              gapH10,
              Expanded(child: _listeOlustur()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _etkinlikEklePaneliniAc,
        backgroundColor: mainPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "${_selectedDay?.day ?? ''} ${_selectedDay?.ayIsmi ?? ''}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _headerOlustur() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${_focusedDay.ayIsmi} ${_focusedDay.year}",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Serif"),
          ),
          const SizedBox(width: 15),
          Column(
            children: [
              GestureDetector(
                onTap: () => _ayDegistir(1),
                child: const Icon(Icons.keyboard_arrow_up, size: 30, color: mainPurple),
              ),
              GestureDetector(
                onTap: () => _ayDegistir(-1),
                child: const Icon(Icons.keyboard_arrow_down, size: 30, color: mainPurple),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _takvimOlustur() {
    return TableCalendar(
      locale: 'tr_TR',
      startingDayOfWeek: StartingDayOfWeek.monday,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

      // Takvime hangi günlerde etkinlik olduğunu tanıtıyoruz
      eventLoader: (day) {
        return _ayinPlanlari.where((p) => isSameDay(p.tarih, day)).toList();
      },

      onPageChanged: (focusedDay) {
        setState(() => _focusedDay = focusedDay);
        _verileriGetir();
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        // Sadece UI'daki listeyi filtrelemek için setState yeterli, tekrar API'ye gitmiyoruz.
      },
      onDayLongPressed: (selectedDay, focusedDay) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GunlukPlanEkrani(secilenTarih: selectedDay))
        ).then((_) => _verileriGetir());
      },
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(fontWeight: FontWeight.bold),
        weekendTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
      calendarBuilders: CalendarBuilders(
        // Önemli günlerin altına kırmızı nokta koyar
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return Positioned(
              bottom: 4,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return null;
        },
        selectedBuilder: (context, day, focusedDay) => Container(
          margin: const EdgeInsets.all(6.0),
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: mainPurple, shape: BoxShape.circle),
          child: Text('${day.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        todayBuilder: (context, day, focusedDay) => Container(
          margin: const EdgeInsets.all(6.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: mainPurple, width: 2),
            shape: BoxShape.circle,
          ),
          child: Text('${day.day}', style: const TextStyle(color: mainPurple, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _listeOlustur() {
    if (_isLoading) return buildLoadingWidget();

    // Filtreleme: Tüm ayın planlarından sadece seçili güne ait olanları al
    final seciliGunPlanlari = _ayinPlanlari.where((plan) =>
    plan.tarih.year == _selectedDay!.year &&
        plan.tarih.month == _selectedDay!.month &&
        plan.tarih.day == _selectedDay!.day
    ).toList();

    if (seciliGunPlanlari.isEmpty) {
      return buildEmptyState("${_selectedDay!.day} ${_selectedDay!.ayIsmi} için kayıt yok.");
    }

    return ListView.separated(
      itemCount: seciliGunPlanlari.length,
      separatorBuilder: (c, i) => gapH10,
      itemBuilder: (context, index) {
        final plan = seciliGunPlanlari[index];
        return GestureDetector(
          onLongPress: () => _silmeDialogGoster(plan),
          child: OnemliGunKarti(plan: plan),
        );
      },
    );
  }

  void _silmeDialogGoster(OnemliGunModel plan) {
    showCustomDialog(
        context: context,
        title: "Silinsin mi?",
        content: "Bu önemli günü silmek istiyor musunuz?",
        positiveBtnText: "Sil",
        onPositivePressed: () async {
          bool silindi = await _planService.onemliGunSil(plan.id!);
          if (mounted && silindi) {
            _verileriGetir();
            showCustomSnackBar(context, "Silindi", isError: true);
          }
        }
    );
  }
}