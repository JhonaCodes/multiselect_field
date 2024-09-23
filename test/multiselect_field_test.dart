import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';

final decoration = BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.black));

const constraint = BoxConstraints(maxWidth: 600);

void main() {
  /// Text title, footer
  group('GOLDEN_TEST_TITLE_FOOTER', () {
    goldenTest(
      'Title and footer text',
      fileName: 'title_footer',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 600),
        children: [
          GoldenTestScenario(
            name: 'No title and no footer',
            child: SizedBox(
              width: 300,
              height: 150,
              child: MultiSelectField(
                data: () => [],
                decoration: decoration,
                onSelect: (value) {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Title',
            child: SizedBox(
              width: 300,
              height: 150,
              child: MultiSelectField(
                title: (isEmpty) => const Text("Title Optional"),
                decoration: decoration,
                data: () => [],
                onSelect: (value) {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Footer',
            child: SizedBox(
              width: 300,
              height: 150,
              child: MultiSelectField(
                data: () => [],
                decoration: decoration,
                onSelect: (value) {},
                footer: const Text('Footer Optional.'),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Title and Footer',
            child: SizedBox(
              width: 300,
              height: 150,
              child: MultiSelectField(
                data: () => [],
                decoration: decoration,
                onSelect: (value) {},
                title: (isEmpty) => const Text("Title Optional"),
                footer: const Text('Footer Optional.'),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Custom title and footer',
      fileName: 'title_footer_custom',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Title and footer custom widget',
            child: SizedBox(
              width: 300,
              height: 150,
              child: MultiSelectField(
                title: (isEmpty) => OutlinedButton(
                    onPressed: () {}, child: const Text('Button on Title')),
                footer: const Chip(label: Text('Chip on Footer')),
                data: () => [],
                decoration: decoration,
                onSelect: (value) {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Title custom widget',
            child: SizedBox(
              width: 300,
              height: 150,
              child: MultiSelectField(
                title: (isEmpty) => OutlinedButton(
                    onPressed: () {}, child: const Text('Button on Title')),
                data: () => [],
                decoration: decoration,
                onSelect: (value) {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Footer custom widget',
            child: SizedBox(
              width: 300,
              height: 150,
              child: MultiSelectField(
                data: () => [],
                decoration: decoration,
                onSelect: (value) {},
                footer: const Chip(label: Text('Chip on Footer')),
              ),
            ),
          ),
        ],
      ),
    );
  });

  group('GOLDEN_TEST_DATA', () {
    goldenTest(
      'Default data',
      fileName: 'default_data',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: "Default empty",
            child: SizedBox(
              width: 300,
              height: 70,
              child: MultiSelectField(
                decoration: decoration,
                data: () => [],
                onSelect: (value) {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: "Default single select",
            child: SizedBox(
              width: 300,
              height: 70,
              child: MultiSelectField(
                decoration: decoration,
                singleSelection: true,
                defaultData: [Choice('1', 'Item')],
                data: () => [],
                onSelect: (value) {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: "Default multiple select",
            child: SizedBox(
              width: 300,
              height: 70,
              child: MultiSelectField(
                decoration: decoration,
                defaultData: [Choice('1', 'Item1'), Choice('2', 'Item2')],
                data: () => [],
                onSelect: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  });
}
