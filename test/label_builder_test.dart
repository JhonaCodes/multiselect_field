import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/multiselect_field.dart';

void main() {
  group('MultiSelectLabel widget', () {
    testWidgets('LabelType.line renders single-line Text without wrap', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: MultiSelectLabel(
                label: 'A very long label that does not fit',
                type: LabelType.line,
              ),
            ),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      expect(textFinder, findsOneWidget);

      final text = tester.widget<Text>(textFinder);
      expect(text.maxLines, isNull);
      expect(text.softWrap, isNull);
      expect(text.overflow, isNull);
    });

    testWidgets('LabelType.wrap allows up to maxLines with ellipsis', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: MultiSelectLabel(
                label: 'A very long label that wraps to two lines',
                type: LabelType.wrap,
                maxLines: 2,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 2);
      expect(text.softWrap, isTrue);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('LabelType.overflow truncates with ellipsis on a single line',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: MultiSelectLabel(
                label: 'A very long label that should be truncated',
                type: LabelType.overflow,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 1);
      expect(text.softWrap, isFalse);
      expect(text.overflow, TextOverflow.ellipsis);
    });
  });

  group('MultiSelectField labelBuilder integration', () {
    testWidgets('default rendering when labelBuilder is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: MultiSelectField<String>(
                label: 'Filter',
                staticLabel: true,
                data: () => const [Choice('1', 'Opt 1')],
                onSelect: (_, __) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Filter'), findsOneWidget);
      // No MultiSelectLabel widget should be present when builder is not used.
      expect(find.byType(MultiSelectLabel), findsNothing);
    });

    testWidgets('uses labelBuilder when provided', (tester) async {
      const longLabel = 'NUI Marketplace North America';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: MultiSelectField<String>(
                label: longLabel,
                staticLabel: true,
                labelBuilder: (label) => MultiSelectLabel(
                  label: label,
                  type: LabelType.wrap,
                  maxLines: 2,
                ),
                data: () => const [Choice('1', 'Opt 1')],
                onSelect: (_, __) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MultiSelectLabel), findsOneWidget);
      expect(find.text(longLabel), findsOneWidget);

      final multiLabel = tester.widget<MultiSelectLabel>(
        find.byType(MultiSelectLabel),
      );
      expect(multiLabel.type, LabelType.wrap);
      expect(multiLabel.maxLines, 2);
    });
  });
}
