import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/standard_multi_select_extension.dart';

void main() {
  group('ChoiceListSearchExtension.filterByValue', () {
    final list = <Choice<String>>[
      Choice('1', 'Orange'),
      Choice('2', 'Apple'),
      Choice('3', 'Banana'),
      Choice('4', 'orangina'),
    ];

    test('returns a copy when text is empty', () {
      final result = list.filterByValue('');
      expect(result, list);
      expect(identical(result, list), isFalse);
    });

    test('matches case-insensitively on partial substrings', () {
      final result = list.filterByValue('OR');
      expect(result.map((e) => e.key), ['1', '4']);
    });

    test('returns empty when nothing matches', () {
      final result = list.filterByValue('zzz');
      expect(result, isEmpty);
    });

    test('returns empty when source list is empty', () {
      final result = <Choice<String>>[].filterByValue('anything');
      expect(result, isEmpty);
    });
  });

  group('ChoiceMenuExtension', () {
    test('isGroupingTitle is true when key is null or empty', () {
      expect(Choice<String>(null, 'Group').isGroupingTitle, isTrue);
      expect(Choice<String>('', 'Group').isGroupingTitle, isTrue);
      expect(Choice<String>('1', 'Item').isGroupingTitle, isFalse);
    });

    test('isSelectedIn returns false for grouping titles', () {
      final title = Choice<String>(null, 'Header');
      expect(title.isSelectedIn([title]), isFalse);
    });

    test('isSelectedIn matches by key against the selected list', () {
      final a = Choice<String>('1', 'A');
      final b = Choice<String>('2', 'B');
      expect(a.isSelectedIn([b, a]), isTrue);
      expect(a.isSelectedIn([b]), isFalse);
    });

    test('isFirstSelectedIn is true only at index 0', () {
      final a = Choice<String>('1', 'A');
      final b = Choice<String>('2', 'B');
      expect(a.isFirstSelectedIn([a, b]), isTrue);
      expect(b.isFirstSelectedIn([a, b]), isFalse);
      expect(a.isFirstSelectedIn([b]), isFalse);
    });
  });

  group('GlobalKeyScrollExtension.ensureVisibleCentered', () {
    testWidgets('completes without throwing when key is unmounted', (
      tester,
    ) async {
      final key = GlobalKey();
      await expectLater(key.ensureVisibleCentered(), completes);
    });

    testWidgets('centers the target inside its scrollable ancestor', (
      tester,
    ) async {
      final key = GlobalKey();
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    for (int i = 0; i < 50; i++)
                      SizedBox(
                        height: 50,
                        key: i == 30 ? key : null,
                        child: Text('item $i'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(controller.offset, 0);

      await key.ensureVisibleCentered();
      await tester.pumpAndSettle();

      expect(controller.offset, greaterThan(0));
    });
  });
}
