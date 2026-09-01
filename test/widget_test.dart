import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cafe_app/main.dart';
import 'package:cafe_app/screens/home_screen.dart';
import 'package:cafe_app/screens/main_navigation_screen.dart';

void main() {
  testWidgets('BrewlyApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BrewlyApp());
    await tester.pumpAndSettle();

    // Verify Onboarding Screen renders headline and CTA
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('HomeScreen renders categories and products', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // Verify Header and Categories
    expect(find.text('Jhon Anderson'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Cappuccino'), findsOneWidget);
  });

  testWidgets('MainNavigationScreen supports drag-to-cart and tab switching', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainNavigationScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Cart'), findsOneWidget);

    // Tap on Cart tab to switch screen
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    // Verify Cart screen is displayed
    expect(find.text('My Cart'), findsOneWidget);

    // Switch back to Home
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Jhon Anderson'), findsOneWidget);
  });
}
