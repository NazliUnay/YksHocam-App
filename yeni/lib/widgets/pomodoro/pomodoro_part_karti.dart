import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class PomodoroPartKarti extends StatelessWidget {
  final String dersAdi;
  final String partNo;
  final bool tamamlandiMi;

  const PomodoroPartKarti({
    super.key,
    required this.dersAdi,
    required this.partNo,
    required this.tamamlandiMi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
      decoration: BoxDecoration(
        color: tamamlandiMi ? mainPurple : Colors.white,
        border: tamamlandiMi ? null : Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dersAdi,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: tamamlandiMi ? Colors.white : Colors.black,
            ),
          ),
          Text(
            partNo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: tamamlandiMi ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}