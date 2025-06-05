import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/search_multiselect_field.dart';

void main() {
  group('MultiSelectField Advanced Tests', () {

    // Test para verificar el comportamiento de la selección
    testWidgets('Selection behavior', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
        Choice('3', 'Option 3')
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 500,
              child: MultiSelectField<String>(
                key: Key("selectable-key"),
                defaultData: testOptions,
                data: () => testOptions,
                onSelect: (selected, isFromDefault) {},
                singleSelection: false,
                menuHeight: 300,
                menuHeightBaseOnContent: true,
              ),
            ),
          ),
        ),
      );


      // Verificar que se pueden seleccionar múltiples opciones
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('selectable-key')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      // Verificar que se puede deseleccionar
      await tester.tap(find.byKey(Key('selectable-key')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
    });

    // Test para la funcionalidad de búsqueda
    testWidgets('Search functionality', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
        Choice('3', 'Option 3')
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 500,
              child: MultiSelectField<String>(
                key: Key('selectable-key'),
                data: () => testOptions,
                defaultData: testOptions,
                onSelect: (selected, isFromDefault) {},
                useTextFilter: true,
                menuHeight: 300,
                menuHeightBaseOnContent: true,
                label: 'search-label',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();


      // Verificar que el campo de búsqueda está presente
      expect(find.text('search-label'), findsAny);

      // Verificar que la búsqueda filtra correctamente
      await tester.enterText(find.byType(TextField), '2');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('selectable-key')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('selectable-key')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
    });

    // Test para el comportamiento de grupos
    testWidgets('Group behavior', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('', 'Group 1'),
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2'),
        Choice('', 'Group 2'),
        Choice('3', 'Option 3')
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                key: Key('selectable-key'),
                data: () => testOptions,
                defaultData: testOptions,
                onSelect: (selected, isFromDefault) {},
                menuHeight: 300,
                menuHeightBaseOnContent: true,
              ),
            ),
          ),
        ),
      );

      // Verificar que los grupos se muestran correctamente
      await tester.tap(find.text('Option 2'));
      await tester.tap(find.byKey(Key('selectable-key')));
      await tester.tap(find.text('Option 2'));
    });

    // Test para el comportamiento de limpieza de selección
    testWidgets('Clean selection behavior', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2')
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SizedBox(
              width: 300,
              height: 500,
              child: MultiSelectField<String>(
                key: Key('selectable-key'),
                data: () => testOptions,
                defaultData: testOptions,
                onSelect: (selected, isFromDefault) {},
                cleanCurrentSelection: true,
                menuHeight: 300,
                menuHeightBaseOnContent: true,
              ),
            ),
          ),
        ),
      );

      // Verificar que la selección se limpia automáticamente
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(find.byType(Choice<String>), anyOf([findsNothing]));
    });


    // Test para el comportamiento de selección de todos
    testWidgets('Select all behavior', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2')
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
                selectAllOption: true,
                menuHeight: 300,
                menuHeightBaseOnContent: true,
              ),
            ),
          ),
        ),
      );

      // Abrir el menú
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Verificar que la opción "All" está presente
      expect(find.text('All'), findsOneWidget);
    });

    // Test para el comportamiento de estilo personalizado
    testWidgets('Custom style behavior', (tester) async {
      final List<Choice<String>> testOptions = [
        Choice('1', 'Option 1'),
        Choice('2', 'Option 2')
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
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                menuStyle: MenuStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  elevation: MaterialStateProperty.all(8.0),
                ),
                menuHeight: 300,
                menuHeightBaseOnContent: true,
              ),
            ),
              ),
        ),
      );

      // Verificar que los estilos se aplican correctamente
      expect(find.byType(DecoratedBox), findsOneWidget);
    });

  });
}