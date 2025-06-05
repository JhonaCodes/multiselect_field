import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';

void main() {
  group('MultiSelectField Error Handling Tests', () {
    // Test de null safety
    testWidgets('Null safety', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', ''), // Usar cadena vacía en lugar de null
        Choice('3', 'Option 3'),
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

      // Verificar que el widget se renderiza sin errores
      expect(tester.takeException(), isNull);
    });

    // Test de manejo de errores en data callback
    testWidgets('Data callback error handling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiSelectField<String>(
            data: () => throw Exception('Data error'),
            onSelect: (selected, isFromDefault) {},
          ),
        ),
      );

      // Verificar que se muestra mensaje de error
      expect(tester.takeException(), isNotNull);
    });

    // Test de manejo de errores en defaultData
    testWidgets('Default data error handling', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: MultiSelectField<String>(
            data: () => testOptions,
            onSelect: (selected, isFromDefault) {},
            defaultData: [Choice('invalid', 'Invalid')],
          ),
        ),
      );

      // Verificar que se muestra mensaje de error
      expect(tester.takeException(), isNotNull);
    });
  });
}
