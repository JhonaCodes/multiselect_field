import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';

void main() {
  group('MultiSelectField Menu Tests', () {
    // Test para verificar el manejo correcto de dimensiones del menú
    testWidgets('Menu dimensions handling', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
        Choice('3', 'Option 3'),
        Choice('4', 'Option 4'),
        Choice('5', 'Option 5'),
        Choice('6', 'Option 6'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => testOptions,
                onSelect: (selected, isFromDefault) {},
                menuWidth: 200,
                menuHeight: 200,
                menuHeightBaseOnContent: true,
              ),
            ),
          ),
        ),
      );

      // Abrir el menú
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Verificar que el menú se ajusta al contenido
      expect(find.byType(MenuItemButton), findsNWidgets(6));
    });

    // Test para verificar el scroll cuando hay muchas opciones
    testWidgets('Menu scrolling behavior', (tester) async {
      final List<Choice<String>> testOptions = List.generate(
        50,
        (index) => Choice(index.toString(), 'Option ${index + 1}'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => testOptions,
                onSelect: (selected, isFromDefault) {},
                menuHeight: 300,
                menuHeightBaseOnContent: false,
              ),
            ),
          ),
        ),
      );

      // Abrir el menú
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Verificar que se puede hacer scroll
      final menuItem = find.byType(MenuItemButton).first;
      await tester.fling(menuItem, const Offset(0, -500), 10000);
      await tester.pumpAndSettle();
      expect(find.text('Option 50'), findsOneWidget);
    });

    // Test para verificar el comportamiento del menú con opciones agrupadas
    testWidgets('Menu grouping behavior', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('', 'Group 1'),
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
        Choice('', 'Group 2'),
        Choice('3', 'Option 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => testOptions,
                onSelect: (selected, isFromDefault) {},
                menuHeight: 200,
                menuHeightBaseOnContent: true,
              ),
            ),
          ),
        ),
      );

      // Abrir el menú
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Verificar que los grupos se muestran correctamente
      expect(find.text('Group 1'), findsOneWidget);
      expect(find.text('Group 2'), findsOneWidget);
      expect(find.byType(MenuItemButton), findsNWidgets(5));
    });

    // Test para verificar el comportamiento del menú con opción "Seleccionar todo"
    testWidgets('Select all behavior', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
        Choice('3', 'Option 3'),
      ];

      List<Choice<String>>? selectedItems;
      bool isFromDefault = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => testOptions,
                onSelect: (selected, isFromDefault) {
                  selectedItems = selected;
                  isFromDefault = isFromDefault;
                },
                menuHeight: 200,
                menuHeightBaseOnContent: true,
                selectAllOption: true,
              ),
            ),
          ),
        ),
      );

      // Abrir el menú
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Verificar que la opción "Seleccionar todo está presente
      expect(find.text('All'), findsOneWidget);

      // Seleccionar "Seleccionar todo"
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // Verificar que todas las opciones están seleccionadas
      expect(selectedItems?.length, 3);
      expect(
        selectedItems?.map((e) => e.value),
        containsAll(['Option 1', 'Option 2', 'Option 3']),
      );
      expect(isFromDefault, false);

      // Verificar que se actualiza correctamente
      await tester.pump();
      expect(selectedItems?.length, 3);
      expect(
        selectedItems?.map((e) => e.value),
        containsAll(['Option 1', 'Option 2', 'Option 3']),
      );
      expect(isFromDefault, false);
    });
  });
}
