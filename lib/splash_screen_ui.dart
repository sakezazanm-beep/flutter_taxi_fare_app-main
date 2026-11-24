import 'dart:async';

import 'package:flutter/material.dart';

import 'taxi_fare_ui.dart';
import 'taxi_illustration.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const TaxiFareUI()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFF7FF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TaxiIllustration(size: 126),
              SizedBox(height: 15),
              Text(
                'Taxi Fare Calculator',
                style: TextStyle(
                  color: Color(0xFF54A5FF),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'คำนวณค่าโดยสารแท็กซี่',
                style: TextStyle(color: Color(0xFF54A5FF), fontSize: 13),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFFB900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
