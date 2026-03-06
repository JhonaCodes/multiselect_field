import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/selection_content.dart';

void main() {
  group('SelectionContent', () {
    final testChoices = [
      Choice<String>('1', 'Option A'),
      Choice<String>('2', 'Option B'),
      Choice<String>('3', 'Option C'),
    ];

    testWidgets('renders items from data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              data: () => testChoices,
              selectAllOption: false,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
      expect(find.text('Option C'), findsOneWidget);
    });

    testWidgets('renders custom menuContent when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              menuContent: const Text('Custom Content'),
              selectAllOption: false,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      expect(find.text('Custom Content'), findsOneWidget);
    });

    testWidgets('renders empty when no data and no menuContent', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              selectAllOption: false,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('shows select all option when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              data: () => testChoices,
              selectAllOption: true,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('renders group titles', (tester) async {
      final groupedChoices = [
        Choice<String>(null, 'Group A'),
        Choice<String>('1', 'Item 1'),
        Choice<String>(null, 'Group B'),
        Choice<String>('2', 'Item 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              data: () => groupedChoices,
              selectAllOption: false,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      expect(find.text('Group A'), findsOneWidget);
      expect(find.text('Group B'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('shows radio buttons in single selection mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              data: () => testChoices,
              selectAllOption: false,
              singleSelection: true,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(3));
    });

    testWidgets('shows checkboxes in multi selection mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              data: () => testChoices,
              selectAllOption: false,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsNWidgets(3));
    });

    testWidgets('calls onToggleSelection when item tapped', (tester) async {
      Choice<String>? tappedChoice;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              data: () => testChoices,
              selectAllOption: false,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (choice) => tappedChoice = choice,
              onToggleSelectAll: () {},
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option A'));
      expect(tappedChoice?.key, '1');
    });

    testWidgets('calls onToggleSelectAll when select all tapped', (
      tester,
    ) async {
      var selectAllCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionContent<String>(
              data: () => testChoices,
              selectAllOption: true,
              singleSelection: false,
              selectAllActive: false,
              selectedChoices: const [],
              onToggleSelection: (_) {},
              onToggleSelectAll: () => selectAllCalled = true,
              isSelected: (_) => false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('All'));
      expect(selectAllCalled, isTrue);
    });
  });
}
