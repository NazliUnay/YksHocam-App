import 'package:flutter/material.dart';
import '../theme/renkler.dart';
import '../theme/stiller.dart'; // gapH20 için

// --- SNACKBAR ---
void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

// --- DIALOG (UYARI PENCERESİ) ---
void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String positiveBtnText,
  required VoidCallback onPositivePressed,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(color: mainPurple, fontWeight: FontWeight.bold)),
      content: Text(content),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("İptal", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: mainPurple),
          onPressed: () {
            Navigator.pop(ctx);
            onPositivePressed();
          },
          child: Text(positiveBtnText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

// --- BOTTOM SHEET ---
void showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, color: Colors.grey.shade300),
            gapH20,
            child,
          ],
        ),
      ),
    ),
  );
}