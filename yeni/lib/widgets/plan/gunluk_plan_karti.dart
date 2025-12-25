import 'package:flutter/material.dart';
import '../../models/plan_model.dart';
import '../../theme/renkler.dart';
import '../../theme/stiller.dart';  // homeCardDecoration için

class GunlukPlanKarti extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const GunlukPlanKarti({
    super.key,
    required this.plan,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: homeCardDecoration().copyWith(
          color: plan.tamamlandiMi ? mainPurple.withOpacity(0.05) : Colors.white,
          // Tamamlandıysa mor çerçeve, değilse siyah
          border: Border.all(
            color: plan.tamamlandiMi ? mainPurple : Colors.black,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  plan.tamamlandiMi ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: mainPurple,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  plan.saat,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: plan.tamamlandiMi ? TextDecoration.lineThrough : null,
                    color: plan.tamamlandiMi ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
            Text(
              plan.baslik,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: "Serif",
                decoration: plan.tamamlandiMi ? TextDecoration.lineThrough : null,
                color: plan.tamamlandiMi ? Colors.grey : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}