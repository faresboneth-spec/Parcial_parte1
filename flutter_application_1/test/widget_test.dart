import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('shows the museum catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const MuseumApp());

    expect(find.text('Museos'), findsOneWidget);
    expect(find.text('Museo de Arte del Río'), findsOneWidget);
    expect(find.text('Museo de Historia Natural Andina'), findsOneWidget);
    expect(find.text('Museo Arqueológico del Altiplano'), findsOneWidget);
    expect(find.text('Casa Museo del Patrimonio Local'), findsOneWidget);
  });

  testWidgets('filters museums by name', (WidgetTester tester) async {
    await tester.pumpWidget(const MuseumApp());

    await tester.enterText(
      find.byKey(const ValueKey('museum-search')),
      'arqueológico',
    );
    await tester.pump();

    expect(find.text('Museo Arqueológico del Altiplano'), findsOneWidget);
    expect(find.text('Museo de Arte del Río'), findsNothing);
    expect(find.text('No se encontraron museos.'), findsNothing);
  });
}
