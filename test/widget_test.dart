import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_card_atlas/app.dart';

void main() {
  testWidgets('renders the complete local catalog', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProductCardAtlasApp());
    await tester.pumpAndSettle();

    expect(find.text('Six products.\nOne clear system.'), findsOneWidget);
    expect(find.text('Aero Headphones'), findsOneWidget);
    expect(find.text('Grid Notebook Set'), findsOneWidget);
  });

  testWidgets('filters products by category', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProductCardAtlasApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Desk'));
    await tester.pumpAndSettle();

    expect(find.text('Fold Lamp'), findsOneWidget);
    expect(find.text('Grid Notebook Set'), findsOneWidget);
    expect(find.text('Aero Headphones'), findsNothing);
  });

  testWidgets('supports saving a product', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProductCardAtlasApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<String>('save-aero-headphones')),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });
}
