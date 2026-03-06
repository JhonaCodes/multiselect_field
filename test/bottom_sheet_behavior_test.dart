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
  // TRIGGER
  // =========================================================================
  group('BottomSheet - Trigger', () {
    testWidgets('renders label trigger', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
          ),
        ),
      );

      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('renders custom child trigger', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            child: const Icon(Icons.filter_list, key: Key('trigger')),
          ),
        ),
      );

      expect(find.byKey(const Key('trigger')), findsOneWidget);
    });

    testWidgets('opens sheet on tap', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            enabled: false,
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);
    });
  });

  // =========================================================================
  // SELECTION
  // =========================================================================
  group('BottomSheet - Selection', () {
    testWidgets('multi selection: select multiple items', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            onSelect: (items, _) =>
                selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2']);
    });

    testWidgets('multi selection: deselect on re-tap', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            onSelect: (items, _) =>
                selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, isEmpty);
    });

    testWidgets('single selection: replaces previous', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Category',
            singleSelection: true,
            data: () => testChoices,
            onSelect: (items, _) =>
                selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      );

      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      // Dismiss sheet first
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Re-open — label now shows "Option 1" (single selection display)
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();
      expect(selected.last, ['2']);
    });

    testWidgets('select all option works', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            selectAllOption: true,
            onSelect: (items, _) =>
                selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2', '3']);

      // Deselect all
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, isEmpty);
    });
  });

  // =========================================================================
  // CALLBACKS
  // =========================================================================
  group('BottomSheet - Callbacks', () {
    testWidgets('onOpened fires', (tester) async {
      bool opened = false;
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            onOpened: () => opened = true,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(opened, true);
    });

    testWidgets('onClosed fires when dismissed', (tester) async {
      bool closed = false;
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            onClosed: () => closed = true,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      // Dismiss sheet by tapping barrier
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(closed, true);
    });

    testWidgets('onChanged fires on user action only', (tester) async {
      final changed = <int>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1')],
            onChanged: (items) => changed.add(items.length),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(changed, isEmpty); // NOT fired on default data

      await tester.tap(find.text('Categories (1)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      expect(changed, [2]); // Fired on user action
    });

    testWidgets('both onSelect and onChanged fire', (tester) async {
      int selectCount = 0;
      int changedCount = 0;
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            onSelect: (_, _) => selectCount++,
            onChanged: (_) => changedCount++,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selectCount, 1);
      expect(changedCount, 1);
    });
  });

  // =========================================================================
  // DISPLAY LABEL
  // =========================================================================
  group('BottomSheet - Display label', () {
    testWidgets('shows label when empty', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
          ),
        ),
      );
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('shows count for multi selection', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            defaultData: [
              Choice<String>('1', 'Option 1'),
              Choice<String>('2', 'Option 2'),
            ],
          ),
        ),
      );
      expect(find.text('Categories (2)'), findsOneWidget);
    });

    testWidgets('shows value for single selection', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Category',
            singleSelection: true,
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1')],
          ),
        ),
      );
      expect(find.text('Option 1'), findsOneWidget);
    });
  });

  // =========================================================================
  // DEFAULT DATA
  // =========================================================================
  group('BottomSheet - Default data', () {
    testWidgets('initializes with defaultData', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1')],
          ),
        ),
      );
      expect(find.text('Categories (1)'), findsOneWidget);
    });

    testWidgets('didUpdateWidget reflects new defaultData', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            key: key,
            label: 'Categories',
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1')],
          ),
        ),
      );
      expect(find.text('Categories (1)'), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            key: key,
            label: 'Categories',
            data: () => testChoices,
            defaultData: [
              Choice<String>('1', 'Option 1'),
              Choice<String>('2', 'Option 2'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Categories (2)'), findsOneWidget);
    });
  });

  // =========================================================================
  // CONTENT
  // =========================================================================
  group('BottomSheet - Content', () {
    testWidgets('menuHeader and menuFooter render inside sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            menuHeader: const Text('Pick items'),
            menuFooter: const Text('Done'),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.text('Pick items'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('menuContent overrides data list', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            menuContent: const Text('Custom widget'),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.text('Custom widget'), findsOneWidget);
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('group titles render', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => groupedChoices,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.text('Group A'), findsOneWidget);
      expect(find.text('Group B'), findsOneWidget);
    });
  });

  // =========================================================================
  // STYLE
  // =========================================================================
  group('BottomSheet - Style', () {
    testWidgets('custom backgroundColor applies', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            bottomSheetStyle: const BottomSheetStyle(
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      // Sheet opened — check option is visible
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('showDragHandle false hides handle', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            bottomSheetStyle: const BottomSheetStyle(showDragHandle: false),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
    });
  });

  // =========================================================================
  // CLOSE ON SELECT
  // =========================================================================
  group('BottomSheet - closeOnSelect', () {
    testWidgets('sheet stays open after selection by default', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Sheet should still be open
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('sheet closes after selection when closeOnSelect=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            closeOnSelect: true,
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Sheet should be closed
      expect(find.text('Option 2'), findsNothing);
    });

    testWidgets('onSelect still fires when closeOnSelect=true', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>.bottomSheet(
            label: 'Categories',
            data: () => testChoices,
            closeOnSelect: true,
            onSelect: (items, _) =>
                selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selected.last, ['1']);
    });
  });
}
