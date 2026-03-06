import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/bottom_sheet_multi_select_field.dart';

void main() {
  final testChoices = [
    Choice<String>('1', 'Alpha'),
    Choice<String>('2', 'Beta'),
    Choice<String>('3', 'Gamma'),
  ];

  Widget buildApp({
    List<Choice<String>> Function()? data,
    void Function(List<Choice<String>>, bool)? onSelect,
    List<Choice<String>>? defaultData,
    Widget? menuContent,
    Widget? menuHeader,
    Widget? menuFooter,
    BottomSheetStyle? bottomSheetStyle,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    bool enabled = true,
    Widget? child,
    bool singleSelection = false,
    bool selectAllOption = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: MultiSelectField<String>.bottomSheet(
          label: 'Test',
          data: data ?? () => testChoices,
          onSelect: onSelect,
          defaultData: defaultData,
          menuContent: menuContent,
          menuHeader: menuHeader,
          menuFooter: menuFooter,
          bottomSheetStyle: bottomSheetStyle,
          onOpened: onOpened,
          onClosed: onClosed,
          enabled: enabled,
          child: child,
          singleSelection: singleSelection,
          selectAllOption: selectAllOption,
        ),
      ),
    );
  }

  group('BottomSheetMultiSelectField', () {
    testWidgets('renders trigger with label', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('renders custom child trigger', (tester) async {
      await tester.pumpWidget(buildApp(
        child: const Text('Custom Trigger'),
      ));
      expect(find.text('Custom Trigger'), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('opens bottom sheet on tap', (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(buildApp(enabled: false));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('calls onOpened when opened', (tester) async {
      var opened = false;
      await tester.pumpWidget(buildApp(onOpened: () => opened = true));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(opened, isTrue);
    });

    testWidgets('calls onClosed when dismissed', (tester) async {
      var closed = false;
      await tester.pumpWidget(buildApp(onClosed: () => closed = true));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      // Dismiss by tapping the barrier
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });

    testWidgets('multi selection works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildApp(
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      expect(selected?.length, 1);
      expect(selected?.first.key, '1');

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(selected?.length, 2);
    });

    testWidgets('single selection works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildApp(
        singleSelection: true,
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      expect(selected?.length, 1);
      expect(selected?.first.key, '1');
    });

    testWidgets('select all option works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildApp(
        selectAllOption: true,
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(selected?.length, 3);
    });

    testWidgets('shows header and footer in sheet', (tester) async {
      await tester.pumpWidget(buildApp(
        menuHeader: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Sheet Header'),
        ),
        menuFooter: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Sheet Footer'),
        ),
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Sheet Header'), findsOneWidget);
      expect(find.text('Sheet Footer'), findsOneWidget);
    });

    testWidgets('renders custom menuContent', (tester) async {
      await tester.pumpWidget(buildApp(
        menuContent: const Text('Custom Sheet Content'),
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Sheet Content'), findsOneWidget);
    });

    testWidgets('default data pre-selects items', (tester) async {
      await tester.pumpWidget(buildApp(
        defaultData: [Choice<String>('1', 'Alpha')],
      ));

      // Label should reflect selection count
      expect(find.text('Test (1)'), findsOneWidget);
    });

    testWidgets('label updates with selection count', (tester) async {
      await tester.pumpWidget(buildApp(
        onSelect: (_, __) {},
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      // Close sheet
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Test (2)'), findsOneWidget);
    });

    testWidgets('single selection shows value in label', (tester) async {
      await tester.pumpWidget(buildApp(
        singleSelection: true,
        defaultData: [Choice<String>('1', 'Alpha')],
      ));

      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('group titles render in sheet', (tester) async {
      final groupedChoices = [
        Choice<String>(null, 'Group 1'),
        Choice<String>('1', 'Item A'),
        Choice<String>(null, 'Group 2'),
        Choice<String>('2', 'Item B'),
      ];

      await tester.pumpWidget(buildApp(
        data: () => groupedChoices,
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Group 1'), findsOneWidget);
      expect(find.text('Group 2'), findsOneWidget);
    });

    testWidgets('custom bottom sheet style applies', (tester) async {
      await tester.pumpWidget(buildApp(
        bottomSheetStyle: const BottomSheetStyle(
          backgroundColor: Colors.amber,
          showDragHandle: false,
          maxHeightFraction: 0.4,
        ),
      ));

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
    });
  });
}
