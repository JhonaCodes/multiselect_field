import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';

final decoration = BoxDecoration(
  color: Colors.grey,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.black),
);

const constraint = BoxConstraints(maxWidth: 600);

final testChoices = [
  Choice<String>('1', 'Option 1'),
  Choice<String>('2', 'Option 2'),
  Choice<String>('3', 'Option 3'),
];

void main() {
  group('GOLDEN_FIELD_WIDTH', () {
    goldenTest(
      'FieldWidth variants',
      fileName: 'field_width_variants',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Default (full width)',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Solutions',
                singleSelection: true,
                decoration: decoration,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'fitContent',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Solutions',
                singleSelection: true,
                fieldWidth: FieldWidth.fitContent,
                decoration: decoration,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'fixed(150)',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Solutions',
                singleSelection: true,
                fieldWidth: FieldWidth.fixed(150),
                decoration: decoration,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'fitContent with selection',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Solutions',
                singleSelection: true,
                fieldWidth: FieldWidth.fitContent,
                defaultData: [Choice<String>('1', 'Option 1')],
                decoration: decoration,
              ),
            ),
          ),
        ],
      ),
    );
  });

  group('GOLDEN_ICON_SPACING', () {
    goldenTest(
      'iconSpacing variants',
      fileName: 'icon_spacing_variants',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Default (0)',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Filter',
                decoration: decoration,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'iconSpacing: 8',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Filter',
                iconSpacing: 8,
                decoration: decoration,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'iconSpacing: 16',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Filter',
                iconSpacing: 16,
                decoration: decoration,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Compact chip-like layout',
      fileName: 'compact_chip_layout',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'fitContent + iconSpacing 2',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Solutions',
                singleSelection: true,
                fieldWidth: FieldWidth.fitContent,
                iconSpacing: 2,
                decoration: decoration,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'fitContent + selection + iconSpacing 2',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Solutions',
                singleSelection: true,
                fieldWidth: FieldWidth.fitContent,
                iconSpacing: 2,
                defaultData: [Choice<String>('2', 'Option 2')],
                decoration: decoration,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'fixed(120) + iconSpacing 4',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>(
                data: () => testChoices,
                label: 'Tags',
                fieldWidth: FieldWidth.fixed(120),
                iconSpacing: 4,
                decoration: decoration,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
