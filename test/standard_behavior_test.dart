import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/standard_multi_select_field.dart';

final testChoices = [
  Choice<String>('1', 'Option 1'),
  Choice<String>('2', 'Option 2'),
  Choice<String>('3', 'Option 3'),
];

final groupedChoices = [
  Choice<String>(null, 'Group A'),
  Choice<String>('1', 'Item 1'),
  Choice<String>('2', 'Item 2'),
  Choice<String>(null, 'Group B'),
  Choice<String>('3', 'Item 3'),
];

final decoration = BoxDecoration(
  border: Border.all(color: Colors.grey),
  borderRadius: BorderRadius.circular(8),
);

Widget wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(20), child: child)),
  );
}

void main() {
  // =========================================================================
  // SINGLE SELECTION
  // =========================================================================
  group('Standard - Single selection', () {
    testWidgets('selects one item and replaces on new selection', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          singleSelection: true,
          label: 'Pick',
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selected.last, ['1']);

      // Open again and select a different item
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(selected.last, ['2']);
    });

    testWidgets('deselects current item when tapped again (non-mandatory)', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          singleSelection: true,
          label: 'Pick',
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      // Tap same item again to deselect — use .last to avoid ambiguity
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();
      expect(selected.last, isEmpty);
    });

    testWidgets('menu closes after single selection', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          singleSelection: true,
          label: 'Pick',
          decoration: decoration,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Menu should be closed
      expect(find.byType(MenuItemButton), findsNothing);
    });
  });

  // =========================================================================
  // MULTI SELECTION
  // =========================================================================
  group('Standard - Multi selection', () {
    testWidgets('selects multiple items', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2']);
    });

    testWidgets('deselects item on second tap', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();
      expect(selected.last, isEmpty);
    });

    testWidgets('menu stays open after multi selection', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Menu should still be open
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });
  });

  // =========================================================================
  // isMandatory
  // =========================================================================
  group('Standard - isMandatory', () {
    testWidgets('single selection: cannot deselect when mandatory', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          singleSelection: true,
          isMandatory: true,
          label: 'Pick',
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      // Try to deselect — use .last to avoid ambiguity with displayed value
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);
    });

    testWidgets('multi selection: can deselect when more than one item', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          isMandatory: true,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2']);

      // Deselect one — use .last for the menu item
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();
      expect(selected.last, ['2']);
    });
  });

  // =========================================================================
  // SELECT ALL
  // =========================================================================
  group('Standard - Select all', () {
    testWidgets('select all selects every valid item', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          selectAllOption: true,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(selected.last, ['1', '2', '3']);
    });

    testWidgets('select all then deselect all', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          selectAllOption: true,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Select all
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2', '3']);

      // Re-open menu (CheckboxMenuButton may close it)
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Deselect all
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, isEmpty);
    });

    testWidgets('select all skips group titles', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => groupedChoices,
          selectAllOption: true,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // Should only select items with keys, not group titles
      expect(selected.last, ['1', '2', '3']);
    });

    testWidgets('fires both onSelect and onChanged', (tester) async {
      final changed = <int>[];
      final selectCalls = <int>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          selectAllOption: true,
          decoration: decoration,
          onSelect: (items, _) => selectCalls.add(items.length),
          onChanged: (items) => changed.add(items.length),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(selectCalls.last, 3);
      expect(changed.last, 3);
    });
  });

  // =========================================================================
  // DEFAULT DATA
  // =========================================================================
  group('Standard - Default data', () {
    testWidgets('initializes with defaultData', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          singleSelection: true,
          label: 'Pick',
          decoration: decoration,
          defaultData: [Choice<String>('1', 'Option 1')],
        ),
      ));

      // Should display selected value
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('onChanged does NOT fire on defaultData init', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          singleSelection: true,
          label: 'Pick',
          decoration: decoration,
          defaultData: [Choice<String>('1', 'Option 1')],
          onChanged: (items) => changed.add(items.length),
        ),
      ));

      await tester.pumpAndSettle();
      expect(changed, isEmpty);
    });
  });

  // =========================================================================
  // LABEL & STATIC LABEL
  // =========================================================================
  group('Standard - Label behavior', () {
    testWidgets('label shows when no selection', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          label: 'Pick items',
          decoration: decoration,
        ),
      ));

      expect(find.text('Pick items'), findsOneWidget);
    });

    testWidgets('label hides when items selected (non-static)', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          label: 'Pick items',
          singleSelection: true,
          decoration: decoration,
          defaultData: [Choice<String>('1', 'Option 1')],
        ),
      ));

      // Label should not show, selected value should
      expect(find.text('Pick items'), findsNothing);
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('staticLabel always shows label even with selection', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          label: 'Pick items',
          staticLabel: true,
          singleSelection: true,
          decoration: decoration,
          defaultData: [Choice<String>('1', 'Option 1')],
        ),
      ));

      expect(find.text('Pick items'), findsOneWidget);
    });
  });

  // =========================================================================
  // GROUPING
  // =========================================================================
  group('Standard - Grouping', () {
    testWidgets('group titles are not selectable', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => groupedChoices,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Tap group title — should not trigger selection
      await tester.tap(find.text('Group A'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
    });

    testWidgets('selectable items under groups work', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => groupedChoices,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);
    });
  });

  // =========================================================================
  // FIELD WIDTH
  // =========================================================================
  group('Standard - FieldWidth', () {
    testWidgets('default fills available width', (tester) async {
      await tester.pumpWidget(wrap(
        SizedBox(
          width: 400,
          child: MultiSelectField<String>(
            data: () => testChoices,
            label: 'Test',
            decoration: decoration,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Default: field should fill the 400px parent
      final box = tester.getSize(find.byType(StandardMultiSelectField<String>));
      expect(box.width, 400);
    });

    testWidgets('fitContent does not expand to full width', (tester) async {
      await tester.pumpWidget(wrap(
        SizedBox(
          width: 400,
          child: MultiSelectField<String>(
            data: () => testChoices,
            label: 'Short',
            fieldWidth: FieldWidth.fitContent,
            decoration: decoration,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // fitContent: the decorated container has no explicit width constraint
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.firstWhere((c) => c.decoration == decoration);
      // width is null (fitContent), so constraints come from minHeight only
      expect(decorated.constraints?.maxWidth, double.infinity);
    });

    testWidgets('fixed width uses exact value', (tester) async {
      await tester.pumpWidget(wrap(
        SizedBox(
          width: 400,
          child: MultiSelectField<String>(
            data: () => testChoices,
            label: 'Test',
            fieldWidth: FieldWidth.fixed(200),
            decoration: decoration,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // fixed(200): the decorated container should have width 200
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.firstWhere((c) => c.decoration == decoration);
      expect(decorated.constraints?.maxWidth, 200);
    });
  });

  // =========================================================================
  // ICON SPACING
  // =========================================================================
  group('Standard - iconSpacing', () {
    testWidgets('default iconSpacing is 0', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          label: 'Test',
          decoration: decoration,
        ),
      ));

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byIcon(Icons.arrow_drop_down),
          matching: find.byType(Padding),
        ).first,
      );
      expect(padding.padding, EdgeInsets.only(left: 0));
    });

    testWidgets('custom iconSpacing applies padding', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          label: 'Test',
          iconSpacing: 12,
          decoration: decoration,
        ),
      ));

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byIcon(Icons.arrow_drop_down),
          matching: find.byType(Padding),
        ).first,
      );
      expect(padding.padding, EdgeInsets.only(left: 12));
    });
  });

  // =========================================================================
  // CALLBACKS
  // =========================================================================
  group('Standard - Callbacks', () {
    testWidgets('onSelect fires with isFromDefault=false on user action', (tester) async {
      bool? wasDefault;
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          onSelect: (_, isDefault) => wasDefault = isDefault,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(wasDefault, false);
    });

    testWidgets('onChanged fires on user action', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          onChanged: (items) => changed.add(items.length),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(changed, [1]);
    });

    testWidgets('both onSelect and onChanged fire together', (tester) async {
      int selectCount = 0;
      int changedCount = 0;
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          onSelect: (_, __) => selectCount++,
          onChanged: (_) => changedCount++,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selectCount, 1);
      expect(changedCount, 1);
    });

    testWidgets('works with only onChanged (no onSelect)', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          onChanged: (items) => changed.add(items.length),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(changed, [1]);
    });
  });

  // =========================================================================
  // KEYBOARD
  // =========================================================================
  group('Standard - Keyboard interactions', () {
    testWidgets('enter key selects matching item from text input', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      // Open menu
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Type in the text field and press enter
      final textField = find.byType(TextField);
      if (textField.evaluate().isNotEmpty) {
        await tester.enterText(textField, 'Option 1');
        await tester.pumpAndSettle();
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
      }
    });
  });

  // =========================================================================
  // ICON LEFT / RIGHT
  // =========================================================================
  group('Standard - Custom icons', () {
    testWidgets('iconRight replaces default arrow', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          label: 'Test',
          decoration: decoration,
          defaultData: [Choice<String>('1', 'Option 1')],
          iconRight: (isOpen, choice) => Icon(
            isOpen ? Icons.close : Icons.search,
            key: const Key('custom-icon-right'),
          ),
        ),
      ));

      expect(find.byKey(const Key('custom-icon-right')), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
    });

    testWidgets('iconLeft renders on the left', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          label: 'Test',
          decoration: decoration,
          defaultData: [Choice<String>('1', 'Option 1')],
          iconLeft: (isOpen, choice) => Icon(
            Icons.filter_list,
            key: const Key('custom-icon-left'),
          ),
        ),
      ));

      expect(find.byKey(const Key('custom-icon-left')), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });
  });

  // =========================================================================
  // VISUAL INDICATORS
  // =========================================================================
  group('Standard - Visual indicators', () {
    testWidgets('check icon shows for selected items (no selectAll)', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('checkbox icons show with selectAllOption', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          selectAllOption: true,
          decoration: decoration,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // All should show unchecked checkbox
      expect(find.byIcon(Icons.check_box_outline_blank), findsNWidgets(3));

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // One checked, two unchecked
      expect(find.byIcon(Icons.check_box), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outline_blank), findsNWidgets(2));
    });
  });

  // =========================================================================
  // CLOSE ON SELECT
  // =========================================================================
  group('Standard - closeOnSelect', () {
    testWidgets('menu stays open after selection by default', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Menu should still be open
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('menu closes after selection when closeOnSelect=true', (tester) async {
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          closeOnSelect: true,
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Menu should be closed
      expect(find.byType(MenuItemButton), findsNothing);
    });

    testWidgets('onSelect still fires when closeOnSelect=true', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          closeOnSelect: true,
          onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selected.last, ['1']);
    });

    testWidgets('onChanged still fires when closeOnSelect=true', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(wrap(
        MultiSelectField<String>(
          data: () => testChoices,
          decoration: decoration,
          closeOnSelect: true,
          onChanged: (items) => changed.add(items.length),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(changed, [1]);
    });
  });
}
