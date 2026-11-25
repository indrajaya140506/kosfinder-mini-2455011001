import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kosfinder_mini/main.dart';

void main() {
  testWidgets('shows the kos list', (WidgetTester tester) async {
    await tester.pumpWidget(const KosFinderApp());

    expect(find.text('KosFinder Mini'), findsOneWidget);
    expect(find.text('Kos Melati'), findsOneWidget);
    expect(find.text('Rp1.200.000 / bulan'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Kos Cempaka'),
      300,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Kos Cempaka'), findsOneWidget);
  });

  testWidgets('searches kos names without case sensitivity', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosFinderApp());

    await tester.enterText(find.byType(TextField), 'mElAtI');
    await tester.pump();

    expect(find.text('Kos Melati'), findsOneWidget);
    expect(find.text('Kos Anggrek'), findsNothing);
  });

  testWidgets('shows an empty state when there are no matches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosFinderApp());

    await tester.enterText(find.byType(TextField), 'tidak ada kos');
    await tester.pump();

    expect(find.text('Kos tidak ditemukan.'), findsOneWidget);
    expect(find.text('Kos Melati'), findsNothing);
  });

  testWidgets('clears the search and restores the full list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosFinderApp());

    await tester.enterText(find.byType(TextField), 'melati');
    await tester.pump();
    expect(find.text('Kos Anggrek'), findsNothing);

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();

    expect(find.text('Kos Melati'), findsOneWidget);
    expect(find.text('Kos Anggrek'), findsOneWidget);
    expect(find.text('Kos tidak ditemukan.'), findsNothing);
  });

  testWidgets('toggles a kos favorite icon', (WidgetTester tester) async {
    await tester.pumpWidget(const KosFinderApp());

    final melatiCard = find.ancestor(
      of: find.text('Kos Melati'),
      matching: find.byType(Card),
    );
    await tester.tap(
      find.descendant(
        of: melatiCard,
        matching: find.byIcon(Icons.favorite_border),
      ),
    );
    await tester.pump();

    expect(
      find.descendant(of: melatiCard, matching: find.byIcon(Icons.favorite)),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(
        of: melatiCard,
        matching: find.byIcon(Icons.favorite),
      ),
    );
    await tester.pump();

    expect(
      find.descendant(
        of: melatiCard,
        matching: find.byIcon(Icons.favorite_border),
      ),
      findsOneWidget,
    );
  });
}
