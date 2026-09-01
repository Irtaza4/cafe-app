import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cafe_app/main.dart';
import 'package:cafe_app/screens/home_screen.dart';

void main() {
  testWidgets('BrewlyApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BrewlyApp());

    // Verify Onboarding Screen renders headline and CTA
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('HomeScreen renders categories and products', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    // Verify Header and Categories
    expect(find.text('Jhon Anderson'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Cappuccino'), findsOneWidget);
  });
}
