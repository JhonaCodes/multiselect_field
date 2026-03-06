import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/multiselect_field.dart';
import 'package:multiselect_field/core/drawer_multi_select_field.dart';

final testChoices = [
  Choice<String>('1', 'Option 1'),
  Choice<String>('2', 'Option 2'),
  Choice<String>('3', 'Option 3'),
];

void main() {
  group('onChanged - Standard variant', () {
    testWidgets('fires on user selection', (tester) async {
      final changed = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>(
              data: () => testChoices,
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      // Open menu
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Tap first item
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(changed, hasLength(1));
      expect(changed.last.first.key, '1');
    });

    testWidgets('does NOT fire on default data', (tester) async {
      final changed = <List<Choice<String>>>[];
      final selected = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>(
              data: () => testChoices,
              singleSelection: true,
              defaultData: [Choice<String>('1', 'Option 1')],
              onSelect: (items, isDefault) => selected.add(List.from(items)),
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // onChanged should NOT have been called
      expect(changed, isEmpty);
    });

    testWidgets('works without onSelect', (tester) async {
      final changed = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>(
              data: () => testChoices,
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(changed, hasLength(1));
      expect(changed.last.first.key, '2');
    });

    testWidgets('fires alongside onSelect on user interaction', (tester) async {
      final changed = <List<Choice<String>>>[];
      final selected = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>(
              data: () => testChoices,
              onSelect: (items, isDefault) => selected.add(List.from(items)),
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(changed, hasLength(1));
      expect(selected, hasLength(1));
    });

    testWidgets('fires on select all', (tester) async {
      final changed = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>(
              data: () => testChoices,
              selectAllOption: true,
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(changed, hasLength(1));
      expect(changed.last, hasLength(3));
    });
  });

  group('onChanged - Chip variant', () {
    testWidgets('fires on user selection', (tester) async {
      final changed = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Filter',
              data: () => testChoices,
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(changed, hasLength(1));
      expect(changed.last.first.key, '1');
    });

    testWidgets('does NOT fire on default data', (tester) async {
      final changed = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Filter',
              data: () => testChoices,
              defaultData: [Choice<String>('1', 'Option 1')],
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(changed, isEmpty);
    });
  });

  group('onChanged - BottomSheet variant', () {
    testWidgets('fires on user selection', (tester) async {
      final changed = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.bottomSheet(
              label: 'Categories',
              data: () => testChoices,
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(changed, hasLength(1));
      expect(changed.last.first.key, '1');
    });

    testWidgets('does NOT fire on default data', (tester) async {
      final changed = <List<Choice<String>>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.bottomSheet(
              label: 'Categories',
              data: () => testChoices,
              defaultData: [Choice<String>('1', 'Option 1')],
              onChanged: (items) => changed.add(List.from(items)),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(changed, isEmpty);
    });
  });

  group('onChanged - Drawer variant', () {
    testWidgets('fires on user selection in scaffold mode', (tester) async {
      final changed = <List<Choice<String>>>[];
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            endDrawer: Drawer(
              child: DrawerMultiSelectField<String>(
                label: 'Filter',
                scaffoldKey: scaffoldKey,
                data: () => testChoices,
                onChanged: (items) => changed.add(List.from(items)),
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(changed, hasLength(1));
      expect(changed.last.first.key, '1');
    });

    testWidgets('does NOT fire on default data', (tester) async {
      final changed = <List<Choice<String>>>[];
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            endDrawer: Drawer(
              child: DrawerMultiSelectField<String>(
                label: 'Filter',
                scaffoldKey: scaffoldKey,
                data: () => testChoices,
                defaultData: [Choice<String>('1', 'Option 1')],
                onChanged: (items) => changed.add(List.from(items)),
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(changed, isEmpty);
    });
  });
}
