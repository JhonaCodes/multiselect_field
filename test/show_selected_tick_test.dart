import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';

final _choices = [
  Choice<String>('1', 'Option 1'),
  Choice<String>('2', 'Option 2'),
];

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

Finder _greenCheck() => find.byWidgetPredicate(
  (w) => w is Icon && w.icon == Icons.check && w.color == Colors.green,
);

void main() {
  group('showSelectedTick', () {
    testWidgets('default true: shows tick on the selected item', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MultiSelectField<String>(
            data: () => _choices,
            defaultData: [_choices.first],
            label: 'Pick',
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(_greenCheck(), findsOneWidget);
    });

    testWidgets('false: hides tick even when item is selected', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MultiSelectField<String>(
            data: () => _choices,
            defaultData: [_choices.first],
            showSelectedTick: false,
            label: 'Pick',
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(_greenCheck(), findsNothing);
    });

    testWidgets('selectAllOption true overrides showSelectedTick', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MultiSelectField<String>(
            data: () => _choices,
            defaultData: [_choices.first],
            selectAllOption: true,
            label: 'Pick',
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(_greenCheck(), findsNothing);
      expect(find.byIcon(Icons.check_box), findsOneWidget);
    });

    testWidgets('no tick when nothing is selected', (tester) async {
      await tester.pumpWidget(
        _wrap(MultiSelectField<String>(data: () => _choices, label: 'Pick')),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(_greenCheck(), findsNothing);
    });
  });

  group('custom menu icons', () {
    testWidgets('menuTrailingIcon overrides default tick', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MultiSelectField<String>(
            data: () => _choices,
            defaultData: [_choices.first],
            label: 'Pick',
            menuTrailingIcon: (choice, isSelected) =>
                isSelected ? const Icon(Icons.star) : null,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(_greenCheck(), findsNothing);
    });

    testWidgets('menuLeadingIcon overrides default selectAll checkbox', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MultiSelectField<String>(
            data: () => _choices,
            defaultData: [_choices.first],
            selectAllOption: true,
            label: 'Pick',
            menuLeadingIcon: (choice, isSelected) =>
                Icon(isSelected ? Icons.favorite : Icons.favorite_border),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.check_box), findsNothing);
    });

    testWidgets('builder returning null falls back to default behavior', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MultiSelectField<String>(
            data: () => _choices,
            defaultData: [_choices.first],
            label: 'Pick',
            menuTrailingIcon: (choice, isSelected) => null,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(_greenCheck(), findsOneWidget);
    });
  });
}
