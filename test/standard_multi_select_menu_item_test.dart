import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/standard_multi_select_menu_item.dart';

Widget _hostMenu({required List<Widget> children}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: MenuAnchor(
          builder: (context, controller, _) => FilledButton(
            onPressed: controller.open,
            child: const Text('open'),
          ),
          menuChildren: children,
        ),
      ),
    ),
  );
}

Future<void> _openMenu(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  group('StandardMultiSelectMenuItem', () {
    testWidgets('renders default Text when itemMenuButton is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _hostMenu(
          children: [
            StandardMultiSelectMenuItem<String>(
              result: Choice<String>('1', 'Apple'),
              isGroupingTitle: false,
              isSelected: false,
              maxWidth: 200,
              menuWidthBaseOnContent: false,
              itemPadding: null,
              selectedItemPadding: null,
              closeOnActivate: false,
              itemKey: null,
              showSelectedTick: true,
              selectAllOption: false,
              buttonStyle: null,
              selectedItemButtonStyle: null,
              mergeSelectedStyle: false,
              itemColor: null,
              isMobile: false,
              titleMenuStyle: null,
              itemMenuStyle: null,
              itemMenuButton: null,
              onTap: () {},
            ),
          ],
        ),
      );
      await _openMenu(tester);

      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('uses itemMenuButton builder when provided', (tester) async {
      await tester.pumpWidget(
        _hostMenu(
          children: [
            StandardMultiSelectMenuItem<String>(
              result: Choice<String>('1', 'Apple'),
              isGroupingTitle: false,
              isSelected: false,
              maxWidth: 200,
              menuWidthBaseOnContent: false,
              itemPadding: null,
              selectedItemPadding: null,
              closeOnActivate: false,
              itemKey: null,
              showSelectedTick: true,
              selectAllOption: false,
              buttonStyle: null,
              selectedItemButtonStyle: null,
              mergeSelectedStyle: false,
              itemColor: null,
              isMobile: false,
              titleMenuStyle: null,
              itemMenuStyle: null,
              itemMenuButton: (c) => Text('custom-${c.value}'),
              onTap: () {},
            ),
          ],
        ),
      );
      await _openMenu(tester);

      expect(find.text('custom-Apple'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets(
      'leadingIcon shows checkbox only when selectAllOption && !isGroupingTitle',
      (tester) async {
        await tester.pumpWidget(
          _hostMenu(
            children: [
              StandardMultiSelectMenuItem<String>(
                result: Choice<String>('1', 'Apple'),
                isGroupingTitle: false,
                isSelected: true,
                maxWidth: 200,
                menuWidthBaseOnContent: false,
                itemPadding: null,
                selectedItemPadding: null,
                closeOnActivate: false,
                itemKey: null,
                showSelectedTick: true,
                selectAllOption: true,
                buttonStyle: null,
                selectedItemButtonStyle: null,
                mergeSelectedStyle: false,
                itemColor: null,
                isMobile: false,
                titleMenuStyle: null,
                itemMenuStyle: null,
                itemMenuButton: null,
                onTap: () {},
              ),
            ],
          ),
        );
        await _openMenu(tester);

        expect(find.byIcon(Icons.check_box), findsOneWidget);
        expect(find.byIcon(Icons.check_box_outline_blank), findsNothing);
      },
    );

    testWidgets('grouping title item ignores onTap (onPressed null)', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _hostMenu(
          children: [
            StandardMultiSelectMenuItem<String>(
              result: Choice<String>(null, 'Header'),
              isGroupingTitle: true,
              isSelected: false,
              maxWidth: 200,
              menuWidthBaseOnContent: false,
              itemPadding: null,
              selectedItemPadding: null,
              closeOnActivate: false,
              itemKey: null,
              showSelectedTick: true,
              selectAllOption: false,
              buttonStyle: null,
              selectedItemButtonStyle: null,
              mergeSelectedStyle: false,
              itemColor: null,
              isMobile: false,
              titleMenuStyle: null,
              itemMenuStyle: null,
              itemMenuButton: null,
              onTap: () => taps++,
            ),
          ],
        ),
      );
      await _openMenu(tester);

      await tester.tap(find.text('Header'));
      await tester.pumpAndSettle();

      expect(taps, 0);
    });
  });

  group('StandardMultiSelectMenuItem group header (D3)', () {
    testWidgets('grouping title does not render a MenuItemButton', (
      tester,
    ) async {
      await tester.pumpWidget(
        _hostMenu(
          children: [
            StandardMultiSelectMenuItem<String>(
              result: Choice<String>(null, 'Header'),
              isGroupingTitle: true,
              isSelected: false,
              maxWidth: 200,
              menuWidthBaseOnContent: false,
              itemPadding: null,
              selectedItemPadding: null,
              closeOnActivate: false,
              itemKey: null,
              showSelectedTick: true,
              selectAllOption: false,
              buttonStyle: null,
              selectedItemButtonStyle: null,
              mergeSelectedStyle: false,
              itemColor: null,
              isMobile: false,
              titleMenuStyle: null,
              itemMenuStyle: null,
              itemMenuButton: null,
              onTap: () {},
            ),
          ],
        ),
      );
      await _openMenu(tester);

      // A group header must read as a non-interactive section label, not a row
      // that looks tappable like a product/item row.
      expect(find.text('Header'), findsOneWidget);
      expect(find.byType(MenuItemButton), findsNothing);
    });

    testWidgets(
      'grouping title paints groupHeaderBackgroundColor as a band',
      (tester) async {
        await tester.pumpWidget(
          _hostMenu(
            children: [
              StandardMultiSelectMenuItem<String>(
                result: Choice<String>(null, 'Header'),
                isGroupingTitle: true,
                isSelected: false,
                maxWidth: 200,
                menuWidthBaseOnContent: false,
                itemPadding: null,
                selectedItemPadding: null,
                closeOnActivate: false,
                itemKey: null,
                showSelectedTick: true,
                selectAllOption: false,
                buttonStyle: null,
                selectedItemButtonStyle: null,
                mergeSelectedStyle: false,
                itemColor: null,
                isMobile: false,
                titleMenuStyle: null,
                itemMenuStyle: null,
                itemMenuButton: null,
                onTap: () {},
                groupHeaderBackgroundColor: const Color(0xFFEEEEEE),
              ),
            ],
          ),
        );
        await _openMenu(tester);

        expect(
          find.byWidgetPredicate(
            (w) => w is Container && w.color == const Color(0xFFEEEEEE),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'group header background is absent (transparent) when color is null',
      (tester) async {
        await tester.pumpWidget(
          _hostMenu(
            children: [
              StandardMultiSelectMenuItem<String>(
                result: Choice<String>(null, 'Header'),
                isGroupingTitle: true,
                isSelected: false,
                maxWidth: 200,
                menuWidthBaseOnContent: false,
                itemPadding: null,
                selectedItemPadding: null,
                closeOnActivate: false,
                itemKey: null,
                showSelectedTick: true,
                selectAllOption: false,
                buttonStyle: null,
                selectedItemButtonStyle: null,
                mergeSelectedStyle: false,
                itemColor: null,
                isMobile: false,
                titleMenuStyle: null,
                itemMenuStyle: null,
                itemMenuButton: null,
                onTap: () {},
                groupHeaderBackgroundColor: null,
              ),
            ],
          ),
        );
        await _openMenu(tester);

        expect(find.text('Header'), findsOneWidget);
        expect(
          find.byWidgetPredicate((w) => w is Container && w.color != null),
          findsNothing,
        );
      },
    );
  });

  group('StandardMultiSelectMenuItem tick colors (D1)', () {
    testWidgets('selectedTickColor recolours the trailing check', (
      tester,
    ) async {
      await tester.pumpWidget(
        _hostMenu(
          children: [
            StandardMultiSelectMenuItem<String>(
              result: Choice<String>('1', 'Apple'),
              isGroupingTitle: false,
              isSelected: true,
              maxWidth: 200,
              menuWidthBaseOnContent: false,
              itemPadding: null,
              selectedItemPadding: null,
              closeOnActivate: false,
              itemKey: null,
              showSelectedTick: true,
              selectAllOption: false,
              buttonStyle: null,
              selectedItemButtonStyle: null,
              mergeSelectedStyle: false,
              itemColor: null,
              isMobile: false,
              titleMenuStyle: null,
              itemMenuStyle: null,
              itemMenuButton: null,
              onTap: () {},
              selectedTickColor: const Color(0xFF2C8FFF),
            ),
          ],
        ),
      );
      await _openMenu(tester);

      final icon = tester.widget<Icon>(find.byIcon(Icons.check));
      expect(icon.color, const Color(0xFF2C8FFF));
    });

    testWidgets('selectAllIconColor recolours the select-all checkbox', (
      tester,
    ) async {
      await tester.pumpWidget(
        _hostMenu(
          children: [
            StandardMultiSelectMenuItem<String>(
              result: Choice<String>('1', 'Apple'),
              isGroupingTitle: false,
              isSelected: true,
              maxWidth: 200,
              menuWidthBaseOnContent: false,
              itemPadding: null,
              selectedItemPadding: null,
              closeOnActivate: false,
              itemKey: null,
              showSelectedTick: false,
              selectAllOption: true,
              buttonStyle: null,
              selectedItemButtonStyle: null,
              mergeSelectedStyle: false,
              itemColor: null,
              isMobile: false,
              titleMenuStyle: null,
              itemMenuStyle: null,
              itemMenuButton: null,
              onTap: () {},
              selectAllIconColor: const Color(0xFF2C8FFF),
            ),
          ],
        ),
      );
      await _openMenu(tester);

      final icon = tester.widget<Icon>(find.byIcon(Icons.check_box));
      expect(icon.color, const Color(0xFF2C8FFF));
    });
  });
}
