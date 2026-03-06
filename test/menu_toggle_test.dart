import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';

final testChoices = [
  Choice<String>('1', 'Option 1'),
  Choice<String>('2', 'Option 2'),
  Choice<String>('3', 'Option 3'),
];

Widget buildTestWidget({FieldWidth? fieldWidth, double iconSpacing = 0}) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: MultiSelectField<String>(
          data: () => testChoices,
          label: 'Filter',
          fieldWidth: fieldWidth,
          iconSpacing: iconSpacing,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('Menu toggle behavior', () {
    testWidgets('first tap opens menu', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Menu items should not be visible
      expect(find.text('Option 1'), findsNothing);

      // Tap to open
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Menu items should be visible
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('second tap closes menu without flicker', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap to open
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      // Tap again to close
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Menu should be closed
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('rapid open-close-open cycle works correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Open
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      // Close
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);

      // Open again
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets(
      'icon shows arrow_drop_up when open, arrow_drop_down when closed',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Closed: arrow_drop_down
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
        expect(find.byIcon(Icons.arrow_drop_up), findsNothing);

        // Open
        await tester.tap(find.byType(InkWell).first);
        await tester.pumpAndSettle();

        // Open: arrow_drop_up
        expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
        expect(find.byIcon(Icons.arrow_drop_down), findsNothing);

        // Close
        await tester.tap(find.byType(InkWell).first);
        await tester.pumpAndSettle();

        // Closed again: arrow_drop_down
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
        expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      },
    );

    testWidgets('toggle works with fitContent', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(fieldWidth: FieldWidth.fitContent, iconSpacing: 2),
      );

      // Open
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      // Close
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('toggle works with fixed width', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(fieldWidth: FieldWidth.fixed(200)),
      );

      // Open
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      // Close
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);
    });
  });
}
