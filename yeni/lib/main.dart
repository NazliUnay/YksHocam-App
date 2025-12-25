import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'theme/renkler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YKS Hocam',
      theme: ThemeData(
        primaryColor: mainPurple,
        useMaterial3: true,
      ),

      initialRoute: AppRoutes.tanitim, // Uygulama ilk açıldığında hangi sayfa gelsin?
      routes: AppRoutes.routes,        // Rota haritamızı buraya veriyoruz
    );
  }
}