import 'package:flutter/material.dart';

import 'splash_screen_ui.dart';

void main() {
  runApp(const TaxiFareApp());
}

class TaxiFareApp extends StatelessWidget {
  const TaxiFareApp({super.key});

  @override
  Widget build(BuildContext context) {
    const taxiYellow = Color(0xFFFFC107);
    return MaterialApp(
      title: 'Taxi Fare Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: taxiYellow),
        scaffoldBackgroundColor: const Color(0xFFFFF7FF),
        fontFamily: 'Kanit',
      ),
      home: const SplashScreenUI(),
    );
  }
}
