import 'package:flutter/material.dart';
import '../../theme/renkler.dart';

class NotAlanToggle extends StatelessWidget {
  final String seciliAlan;
  final Function(String) onAlanDegisti;

  const NotAlanToggle({
    super.key,
    required this.seciliAlan,
    required this.onAlanDegisti,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: ["TYT", "AYT"].map((e) {
                  bool isActive = seciliAlan == e;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onAlanDegisti(e),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive ? mainPurple : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}