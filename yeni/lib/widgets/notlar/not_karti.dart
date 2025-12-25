import 'package:flutter/material.dart';
import '../../models/not_model.dart';

class NotKarti extends StatelessWidget {
  final NotModel not;
  final Function(NotModel) onSil;
  final Function(NotModel) onSec;
  final bool secimModu;

  const NotKarti({
    super.key,
    required this.not,
    required this.onSil,
    required this.onSec,
    required this.secimModu,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainPurple = const Color(0xFF8A2BE2);

    return Dismissible(
      key: Key(not.id.toString()),

      // Sadece sağdan sola (Silme yönü)
      direction: DismissDirection.endToStart,

      // ARKA PLAN: Sadece Silme (Kırmızı)
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),

      // ONAY MEKANİZMASI
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Silinsin mi?"),
            content: const Text("Bu not kalıcı olarak silinecek."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("SİL", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        onSil(not);
      },

      // KART GÖRÜNÜMÜ
      child: GestureDetector(
        onLongPress: () => onSec(not),
        onTap: () {
          if (secimModu) onSec(not);
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: not.seciliMi ? mainPurple : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),

          child: Center(
            child: Text(
              not.icerik,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: not.seciliMi ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}