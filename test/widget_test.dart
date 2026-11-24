import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_taxi_fare_app/main.dart';

Future<void> _openCalculator(WidgetTester tester) async {
  await tester.pumpWidget(const TaxiFareApp());
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('splash opens the taxi fare calculator', (tester) async {
    await _openCalculator(tester);

    expect(find.text('คำนวณค่าโดยสารแท็กซี่'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byIcon(Icons.route_rounded), findsOneWidget);
    expect(find.byIcon(Icons.access_time_filled), findsOneWidget);
    expect(find.textContaining('35 บาท'), findsNothing);
  });

  testWidgets('shows a red warning when required fields are blank', (
    tester,
  ) async {
    await _openCalculator(tester);
    await tester.ensureVisible(find.text('คำนวณค่าโดยสาร'));
    await tester.tap(find.text('คำนวณค่าโดยสาร'));
    await tester.pumpAndSettle();

    expect(find.text('กรุณากรอกระยะทางและเวลารถติด'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    final warningIcon = tester.widget<Icon>(
      find.byIcon(Icons.warning_amber_rounded),
    );
    expect(warningIcon.color, const Color(0xFFFFD54F));

    await tester.enterText(find.byType(TextFormField).first, '12');
    await tester.pumpAndSettle();
    expect(find.text('กรุณากรอกเวลารถติด'), findsNWidgets(2));
  });

  testWidgets('calculates fare using the displayed rate bands', (tester) async {
    await _openCalculator(tester);

    await tester.enterText(find.byType(TextFormField).at(0), '25');
    await tester.enterText(find.byType(TextFormField).at(1), '7');
    await tester.ensureVisible(find.text('คำนวณค่าโดยสาร'));
    await tester.tap(find.text('คำนวณค่าโดยสาร'));
    await tester.pumpAndSettle();

    expect(find.text('224.50'), findsOneWidget);
    expect(find.text('กรุณากรอกระยะทางและเวลารถติด'), findsNothing);
  });
}
