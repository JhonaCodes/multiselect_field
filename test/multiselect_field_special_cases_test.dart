import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/search_multiselect_field.dart';

void main() {
  group('MultiSelectField Special Cases Tests', () {
    // Test de copiar/pegar
    testWidgets('Copy/paste functionality', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MultiSelectField<String>(
              data: () => testOptions,
              onSelect: (selected, isFromDefault) {},
            ),
          ),
        ),
      );

      // Simular copiar/pegar
      await tester.sendKeyEvent(LogicalKeyboardKey.controlRight);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
      await tester.pump();

      // Verificar que no hay errores
      expect(tester.takeException(), isNull);
    });

    // Test de drag and drop
    testWidgets('Drag and drop functionality', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: LayoutBuilder(
              builder: (context, constraints) => MultiSelectField<String>(
                data: () => testOptions,
                onSelect: (selected, isFromDefault) {},
                menuHeight: 300, // Añadir altura explícita
                menuWidth: 200, // Añadir ancho explícito
                menuHeightBaseOnContent: true,
                useTextFilter:
                    true, // Añadir filtro de texto para facilitar la búsqueda
              ),
            ),
          ),
        ),
      );

      // Abrir el menú primero
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Simular drag and drop
      await tester.drag(
        find.byType(SearchMultiselectField),
        const Offset(100, 0),
      );
      await tester.pump();

      // Verificar que no hay errores
      expect(tester.takeException(), isNull);
    });
  });
}
