import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class PomodoroTimerGostergesi extends StatelessWidget {
  final int toplamSaniye;
  final int kalanSaniye;

  const PomodoroTimerGostergesi({
    super.key,
    required this.toplamSaniye,
    required this.kalanSaniye,
  });

  String _formatSure(int saniye) {
    int dk = saniye ~/ 60;
    int sn = saniye % 60;
    return "${dk < 10 ? '0' : ''}$dk dk\n${sn < 10 ? '0' : ''}$sn sn";
  }

  @override
  Widget build(BuildContext context) {
    // İlerleme çubuğu değeri (0.0 ile 1.0 arası)
    double progress = toplamSaniye > 0 ? kalanSaniye / toplamSaniye : 0;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              // mainPurple -> theme/renkler.dart
              color: mainPurple,
              backgroundColor: Colors.grey.shade100,
            ),
          ),
          Text(
            _formatSure(kalanSaniye),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              fontFamily: "Serif",
            ),
          ),
        ],
      ),
    );
  }
}