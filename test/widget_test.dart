import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:museo_catalogo/main.dart';

void main() {
  testWidgets('shows the museum catalog', (tester) async {
    await tester.pumpWidget(const MuseumCatalogApp());

    expect(find.text('Museos'), findsOneWidget);
    expect(find.text('Museo de Arte del Río'), findsOneWidget);
    expect(find.text('Museo de Historia Natural Andina'), findsOneWidget);
    expect(find.byType(MuseumCard), findsNWidgets(4));
  });

  testWidgets('filters museums by name', (tester) async {
    await tester.pumpWidget(const MuseumCatalogApp());
    await tester.enterText(find.byType(TextField), 'Arqueológico');
    await tester.pump();

    expect(find.byType(MuseumCard), findsOneWidget);
    expect(find.text('Museo Arqueológico del Altiplano'), findsOneWidget);
    expect(find.text('Museo de Arte del Río'), findsNothing);
  });

  testWidgets('shows an empty state when there are no matches', (tester) async {
    await tester.pumpWidget(const MuseumCatalogApp());
    await tester.enterText(find.byType(TextField), 'no existe');
    await tester.pump();

    expect(find.byType(MuseumCard), findsNothing);
    expect(find.text('No encontramos museos con ese nombre.'), findsOneWidget);
  });
}
