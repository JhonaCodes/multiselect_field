import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/standard_multi_select_extension.dart';

void main() {
  final options = <Choice<String>>[
    Choice('1', 'Option 1'),
    Choice('2', 'Option 2'),
    Choice('3', 'Option 3'),
  ];

  Widget wrap(Widget child) => MaterialApp(
    home: Material(child: SizedBox(width: 300, height: 400, child: child)),
  );

  group('itemDividerColor', () {
    testWidgets('renders hairline dividers between option rows when set', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>(
            data: () => options,
            onSelect: (_, __) {},
            itemDividerColor: const Color(0xFF00FF00),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // 3 options -> 2 dividers between them.
      final dividers = tester
          .widgetList<Divider>(find.byType(Divider))
          .where((d) => d.color == const Color(0xFF00FF00))
          .toList();
      expect(dividers.length, 2);
    });

    testWidgets('dividers work with menuWidthBaseOnContent: true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>(
            data: () => options,
            onSelect: (_, __) {},
            menuWidthBaseOnContent: true,
            itemDividerColor: const Color(0xFF00FF00),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final dividers = tester
          .widgetList<Divider>(find.byType(Divider))
          .where((d) => d.color == const Color(0xFF00FF00))
          .toList();
      expect(dividers.length, 2);
    });

    testWidgets('renders no dividers by default', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>(data: () => options, onSelect: (_, __) {}),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsNothing);
    });
  });

  group('selectedItemMenuStyle', () {
    testWidgets('merges onto the selected row label only', (tester) async {
      await tester.pumpWidget(
        wrap(
          MultiSelectField<String>(
            data: () => options,
            defaultData: [const Choice('1', 'Option 1')],
            singleSelection: true,
            onSelect: (_, __) {},
            showSelectedTick: false,
            selectedItemMenuStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      Text labelOf(String value) => tester.widget<Text>(
        find.descendant(
          of: find.byType(MenuItemButton),
          matching: find.text(value),
        ),
      );

      expect(labelOf('Option 1').style?.fontWeight, FontWeight.w600);
      expect(labelOf('Option 2').style?.fontWeight, isNot(FontWeight.w600));
    });
  });

  group('resolveItemStyle pressedColor', () {
    testWidgets('overlay is transparent when pressedColor is null', (
      tester,
    ) async {
      late ButtonStyle style;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              style = context.resolveItemStyle(
                isGroupingTitle: false,
                isSelected: false,
                isMobile: true,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      final overlay = style.overlayColor!;
      expect(overlay.resolve({WidgetState.pressed}), Colors.transparent);
    });

    testWidgets('overlay uses pressedColor on pressed/hovered when set', (
      tester,
    ) async {
      const pressed = Color(0x14FFFFFF);
      late ButtonStyle style;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              style = context.resolveItemStyle(
                isGroupingTitle: false,
                isSelected: false,
                isMobile: true,
                pressedColor: pressed,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      final overlay = style.overlayColor!;
      expect(overlay.resolve({WidgetState.pressed}), pressed);
      expect(overlay.resolve({WidgetState.hovered}), pressed);
      expect(overlay.resolve(<WidgetState>{}), Colors.transparent);
    });
  });
}
