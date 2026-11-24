import 'package:flutter/material.dart';

class TaxiIllustration extends StatelessWidget {
  const TaxiIllustration({super.key, this.size = 100});

  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/taxi_icon.png',
    width: size * 1.45,
    height: size,
    fit: BoxFit.contain,
    semanticLabel: 'ไอคอนรถแท็กซี่',
  );
}
