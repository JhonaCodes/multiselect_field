import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';

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

Widget wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  );
}

void main() {
  // =========================================================================
  // MENU TOGGLE
  // =========================================================================
  group('Chip - Menu toggle', () {
    testWidgets('opens on tap', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('closes on second tap', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      // Close by tapping chip again
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('auto-closes on single selection', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            singleSelection: true,
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Menu should have closed
      expect(find.byType(ListTile), findsNothing);
    });
  });

  // =========================================================================
  // CALLBACKS
  // =========================================================================
  group('Chip - Callbacks', () {
    testWidgets('onMenuOpened fires when menu opens', (tester) async {
      bool opened = false;
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            onMenuOpened: () => opened = true,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(opened, true);
    });

    testWidgets('onMenuClosed fires when menu closes', (tester) async {
      bool closed = false;
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            onMenuClosed: () => closed = true,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(closed, false);

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(closed, true);
    });

    testWidgets('onSelect fires with isFromDefault=false', (tester) async {
      bool? wasDefault;
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            onSelect: (_, isDefault) => wasDefault = isDefault,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(wasDefault, false);
    });

    testWidgets('onChanged fires on user interaction', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            onChanged: (items) => changed.add(items.length),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(changed, [1]);
    });

    testWidgets('onChanged does NOT fire on defaultData init', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1')],
            onChanged: (items) => changed.add(items.length),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(changed, isEmpty);
    });

    testWidgets('onChanged fires on select all', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            selectAllOption: true,
            onChanged: (items) => changed.add(items.length),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(changed.last, 3);
    });
  });

  // =========================================================================
  // SELECTION
  // =========================================================================
  group('Chip - Selection', () {
    testWidgets('single selection: deselects on re-tap', (tester) async {
      final selected = <int>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            singleSelection: true,
            data: () => testChoices,
            onSelect: (items, _) => selected.add(items.length),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, 1);

      // Re-open and tap same item — use .last to target menu item (not chip label)
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();
      expect(selected.last, 0);
    });

    testWidgets('multi selection: select all then deselect all', (
      tester,
    ) async {
      final selected = <int>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            selectAllOption: true,
            onSelect: (items, _) => selected.add(items.length),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, 3);

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, 0);
    });

    testWidgets('select all excludes group titles', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => groupedChoices,
            selectAllOption: true,
            onSelect: (items, _) =>
                selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2', '3']);
    });
  });

  // =========================================================================
  // DISPLAY LABEL
  // =========================================================================
  group('Chip - Display label', () {
    testWidgets('shows original label when no selection', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
          ),
        ),
      );

      expect(find.text('Filter'), findsOneWidget);
    });

    testWidgets('shows count for multi selection', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(find.text('Filter (2)'), findsOneWidget);
    });

    testWidgets('shows value for single selection', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            singleSelection: true,
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsOneWidget);
    });
  });

  // =========================================================================
  // ENABLED / DISABLED
  // =========================================================================
  group('Chip - Enabled/Disabled', () {
    testWidgets('disabled chip does not open menu', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            enabled: false,
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);
    });
  });

  // =========================================================================
  // MENU CONTENT
  // =========================================================================
  group('Chip - Menu content', () {
    testWidgets('menuContent overrides data list', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            menuContent: const Text('Custom content'),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.text('Custom content'), findsOneWidget);
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('menuHeader and menuFooter render', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            menuHeader: const Text('Header'),
            menuFooter: const Text('Footer'),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });
  });

  // =========================================================================
  // DROPDOWN ICON
  // =========================================================================
  group('Chip - Dropdown icon', () {
    testWidgets('shows dropdown icon by default', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('hides dropdown icon when showDropdownIcon=false', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            showDropdownIcon: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
    });
  });

  // =========================================================================
  // DEFAULT DATA
  // =========================================================================
  group('Chip - Default data', () {
    testWidgets('initializes with defaultData', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            singleSelection: true,
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1')],
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('didUpdateWidget reflects new defaultData', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            key: key,
            label: 'Filter',
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1')],
          ),
        ),
      );

      expect(find.text('Filter (1)'), findsOneWidget);

      // Rebuild with different defaultData
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            key: key,
            label: 'Filter',
            data: () => testChoices,
            defaultData: [
              Choice<String>('1', 'Option 1'),
              Choice<String>('2', 'Option 2'),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Filter (2)'), findsOneWidget);
    });
  });

  // =========================================================================
  // LEADING / TRAILING
  // =========================================================================
  group('Chip - Leading & Trailing', () {
    testWidgets('leading widget renders', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            leading: const Icon(Icons.filter_list, key: Key('lead')),
          ),
        ),
      );

      expect(find.byKey(const Key('lead')), findsOneWidget);
    });

    testWidgets('trailing widget renders', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => testChoices,
            trailing: const Icon(Icons.info, key: Key('trail')),
          ),
        ),
      );

      expect(find.byKey(const Key('trail')), findsOneWidget);
    });
  });

  // =========================================================================
  // GROUP TITLES
  // =========================================================================
  group('Chip - Group titles', () {
    testWidgets('group titles render as non-selectable text', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.chip(
            label: 'Filter',
            data: () => groupedChoices,
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      expect(find.text('Group A'), findsOneWidget);
      expect(find.text('Group B'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
    });
  });
}
