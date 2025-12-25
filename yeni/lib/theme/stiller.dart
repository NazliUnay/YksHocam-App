import 'package:flutter/material.dart';
import 'renkler.dart';

// --- BOŞLUKLAR ---
const Widget gapH10 = SizedBox(height: 10);
const Widget gapH20 = SizedBox(height: 20);
const Widget gapH30 = SizedBox(height: 30);
const Widget gapW10 = SizedBox(width: 10);
const Widget gapW20 = SizedBox(width: 20);

// --- METİN STİLLERİ ---
const TextStyle headerStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle subLinkStyle = TextStyle(
  fontSize: 18,
  color: mainPurple,
);

// --- GÖLGELER ---
final List<BoxShadow> customShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(0, 5),
    spreadRadius: 1,
  )
];

// --- KUTU DEKORASYONLARI ---
BoxDecoration homeCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.black, width: 1),
  );
}

BoxDecoration timerCardDecoration() {
  return BoxDecoration(
    color: mainPurple,
    borderRadius: BorderRadius.circular(20),
  );
}

// --- INPUT DECORATION (TextField Tasarımı) ---
InputDecoration customInputDecoration({required String label, required IconData icon}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: mainPurple),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    labelStyle: TextStyle(color: Colors.grey.shade800),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.grey.shade600),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: mainPurple, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  );
}