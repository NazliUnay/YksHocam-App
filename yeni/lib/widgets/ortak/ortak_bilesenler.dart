import 'package:flutter/material.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';

// --- BUTON ---
Widget customElevatedButton({
  required String text,
  required VoidCallback? onPressed,
  bool isLoading = false,
}) {
  return ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: mainPurple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5,
    ),
    child: isLoading
        ? const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
    )
        : Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}

// --- APPBAR ---
AppBar customAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: mainPurple),
      onPressed: () => Navigator.pop(context),
    ),
  );
}

// --- BOŞ LİSTE DURUMU ---
Widget buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey.shade300),
        gapH20,
        Text(
          message,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
        ),
      ],
    ),
  );
}

// --- LOADING ---
Widget buildLoadingWidget() {
  return const Center(
    child: CircularProgressIndicator(
      color: mainPurple,
      strokeWidth: 3,
    ),
  );
}

// --- ALT LİNK (Kayıt Ol vs) ---
Widget customNavigationLink({
  required String text,
  required String linkText,
  required VoidCallback onTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: const TextStyle(
          color: mainPurple,
          fontSize: 20,
        ),
      ),
      GestureDetector(
        onTap: onTap,
        child: Text(
          linkText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: mainPurple,
            fontSize: 20,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ],
  );
}

// --- ARKA PLAN SÜSLEMELERİ ---
List<Widget> buildAppBackground() {
  return [
    Positioned(
      top: 0,
      left: 0,
      child: Image.asset('assets/images/solust.png', width: 120),
    ),
    Positioned(
      top: 0,
      right: 0,
      child: Image.asset('assets/images/sagust.png', width: 100),
    ),
    Positioned(
      bottom: 0,
      right: 0,
      child: Image.asset('assets/images/sagalt.png', width: 140),
    ),
  ];
}
Widget buildSideDecorator() {
  return Container(
    width: 6,
    margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
    decoration: BoxDecoration(
      color: mainPurple,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}