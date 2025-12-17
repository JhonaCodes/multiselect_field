import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';

void main() {
  group('ChipMultiSelectField', () {
    testWidgets('renders chip with label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Test Label',
              data: () => [Choice('1', 'Option')],
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('renders chip with custom color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Status',
              chipStyle: ChipStyle.withColor(Colors.blue),
              data: () => [Choice('1', 'Active'), Choice('2', 'Inactive')],
            ),
          ),
        ),
      );

      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('renders chip with leading icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Category',
              leading: const Icon(Icons.category, size: 16),
              chipStyle: ChipStyle.withColor(Colors.green),
              data: () => [Choice('1', 'Tech'), Choice('2', 'Health')],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
    });

    testWidgets('opens menu on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Filter',
              data: () => [Choice('1', 'Option 1'), Choice('2', 'Option 2')],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('selects item in single selection mode', (tester) async {
      String? selectedKey;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Filter',
              singleSelection: true,
              data: () => [Choice('1', 'Option 1'), Choice('2', 'Option 2')],
              onSelect: (selected, _) {
                selectedKey = selected.isNotEmpty ? selected.first.key : null;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selectedKey, '1');
    });

    testWidgets('selects multiple items in multi selection mode', (
      tester,
    ) async {
      List<String> selectedKeys = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Filter',
              singleSelection: false,
              data: () => [Choice('1', 'Option 1'), Choice('2', 'Option 2')],
              onSelect: (selected, _) {
                selectedKeys = selected.map((c) => c.key!).toList();
              },
            ),
          ),
        ),
      );

      // Open menu and select first item
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Select second item (menu stays open in multi-select)
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(selectedKeys, containsAll(['1', '2']));
    });

    testWidgets('displays group titles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Cars',
              data: () => [
                Choice(null, 'Sports'),
                Choice('1', 'Ferrari'),
                Choice('2', 'Porsche'),
                Choice(null, 'SUV'),
                Choice('3', 'Range Rover'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cars'));
      await tester.pumpAndSettle();

      expect(find.text('Sports'), findsOneWidget);
      expect(find.text('SUV'), findsOneWidget);
    });

    testWidgets('custom menuContent is displayed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Custom',
              menuContent: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Custom Content'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Content'), findsOneWidget);
    });

    testWidgets('disabled chip does not open menu', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Disabled',
              enabled: false,
              data: () => [Choice('1', 'Option')],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(find.text('Option'), findsNothing);
    });

    testWidgets('renders with different chip sizes', (tester) async {
      for (final size in [
        ChipSize.extraSmall,
        ChipSize.small,
        ChipSize.medium,
        ChipSize.large,
        ChipSize.extraLarge,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MultiSelectField<String>.chip(
                label: 'Size Test',
                chipSize: size,
                data: () => [Choice('1', 'Option')],
              ),
            ),
          ),
        );

        expect(find.text('Size Test'), findsOneWidget);
      }
    });

    testWidgets('renders with custom chip size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Custom Size',
              chipSize: const ChipSize(
                fontSize: 10,
                iconSize: 12,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                borderRadius: 10,
                spacing: 2,
              ),
              data: () => [Choice('1', 'Option')],
            ),
          ),
        ),
      );

      expect(find.text('Custom Size'), findsOneWidget);
    });

    testWidgets('ChipStyle.styled applies correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiSelectField<String>.chip(
              label: 'Styled',
              chipStyle: ChipStyle.styled(
                color: Colors.indigo,
                size: ChipSize.small,
              ),
              data: () => [Choice('1', 'Option')],
            ),
          ),
        ),
      );

      expect(find.text('Styled'), findsOneWidget);
    });
  });

  group('ChipSize', () {
    test('extraSmall has correct values', () {
      expect(ChipSize.extraSmall.fontSize, 11);
      expect(ChipSize.extraSmall.iconSize, 14);
      expect(ChipSize.extraSmall.borderRadius, 12);
    });

    test('small has correct values', () {
      expect(ChipSize.small.fontSize, 12);
      expect(ChipSize.small.iconSize, 16);
      expect(ChipSize.small.borderRadius, 14);
    });

    test('medium has correct values', () {
      expect(ChipSize.medium.fontSize, 14);
      expect(ChipSize.medium.iconSize, 20);
      expect(ChipSize.medium.borderRadius, 20);
    });

    test('large has correct values', () {
      expect(ChipSize.large.fontSize, 16);
      expect(ChipSize.large.iconSize, 24);
      expect(ChipSize.large.borderRadius, 24);
    });

    test('extraLarge has correct values', () {
      expect(ChipSize.extraLarge.fontSize, 18);
      expect(ChipSize.extraLarge.iconSize, 28);
      expect(ChipSize.extraLarge.borderRadius, 28);
    });

    test('custom size can be created', () {
      const custom = ChipSize(
        fontSize: 15,
        iconSize: 18,
        padding: EdgeInsets.all(10),
        borderRadius: 16,
        spacing: 5,
      );

      expect(custom.fontSize, 15);
      expect(custom.iconSize, 18);
      expect(custom.borderRadius, 16);
      expect(custom.spacing, 5);
    });
  });

  group('ChipStyle', () {
    test('withColor creates correct style', () {
      final style = ChipStyle.withColor(Colors.blue);

      expect(style.activeBorderColor, Colors.blue);
      expect(style.activeTextColor, Colors.blue);
      expect(style.activeIconColor, Colors.blue);
      expect(style.backgroundColor, Colors.transparent);
    });

    test('styled creates correct style with size', () {
      final style = ChipStyle.styled(color: Colors.red, size: ChipSize.small);

      expect(style.activeBorderColor, Colors.red);
      expect(style.iconSize, ChipSize.small.iconSize);
      expect(style.textStyle?.fontSize, ChipSize.small.fontSize);
    });
  });
}
