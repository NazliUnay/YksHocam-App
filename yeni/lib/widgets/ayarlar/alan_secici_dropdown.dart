import 'package:flutter/material.dart';
import '../../theme/renkler.dart';
class AlanSeciciDropdown extends StatelessWidget {
  final String secilenAlan;
  final List<String> alanlar;
  final Function(String?) onChanged;

  const AlanSeciciDropdown({
    super.key,
    required this.secilenAlan,
    required this.alanlar,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("ALAN",
            style: TextStyle(
                color: mainPurple, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade500),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: secilenAlan,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                isExpanded: true,
                items: alanlar.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}