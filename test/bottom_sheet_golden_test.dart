import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';

const constraint = BoxConstraints(maxWidth: 600);

final testChoices = [
  Choice<String>('1', 'Option 1'),
  Choice<String>('2', 'Option 2'),
  Choice<String>('3', 'Option 3'),
];

final groupedChoices = [
  Choice<String>(null, 'Group A'),
  Choice<String>('1', 'Item 1'),
  Choice<String>('2', 'Item 2'),
  Choice<String>(null, 'Group B'),
  Choice<String>('3', 'Item 3'),
];

void main() {
  group('GOLDEN_BOTTOM_SHEET_TRIGGER', () {
    goldenTest(
      'Bottom sheet trigger variants',
      fileName: 'bottom_sheet_trigger',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Default trigger',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>.bottomSheet(
                label: 'Categories',
                data: () => testChoices,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Trigger with selection count',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>.bottomSheet(
                label: 'Categories',
                data: () => testChoices,
                defaultData: [
                  Choice<String>('1', 'Option 1'),
                  Choice<String>('2', 'Option 2'),
                ],
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Single selection with value',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>.bottomSheet(
                label: 'Category',
                singleSelection: true,
                data: () => testChoices,
                defaultData: [Choice<String>('1', 'Option 1')],
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Disabled trigger',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>.bottomSheet(
                label: 'Categories',
                enabled: false,
                data: () => testChoices,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Bottom sheet custom child trigger',
      fileName: 'bottom_sheet_custom_trigger',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Icon button trigger',
            child: SizedBox(
              width: 60,
              height: 60,
              child: MultiSelectField<String>.bottomSheet(
                label: 'Filter',
                data: () => testChoices,
                child: const Icon(Icons.filter_list, size: 28),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Chip trigger',
            child: SizedBox(
              width: 150,
              height: 60,
              child: MultiSelectField<String>.bottomSheet(
                label: 'Filter',
                data: () => testChoices,
                child: const Chip(label: Text('Select items')),
              ),
            ),
          ),
        ],
      ),
    );
  });

  group('GOLDEN_BOTTOM_SHEET_CONTENT', () {
    goldenTest(
      'Bottom sheet content - multi selection',
      fileName: 'bottom_sheet_content_multi',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Multi selection with checkboxes',
            child: SizedBox(
              width: 350,
              height: 300,
              child: Material(
                child: SelectionContentPreview<String>(
                  choices: testChoices,
                  singleSelection: false,
                  selectAllOption: false,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Multi selection with select all',
            child: SizedBox(
              width: 350,
              height: 350,
              child: Material(
                child: SelectionContentPreview<String>(
                  choices: testChoices,
                  singleSelection: false,
                  selectAllOption: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Bottom sheet content - single selection',
      fileName: 'bottom_sheet_content_single',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Single selection with radio buttons',
            child: SizedBox(
              width: 350,
              height: 300,
              child: Material(
                child: SelectionContentPreview<String>(
                  choices: testChoices,
                  singleSelection: true,
                  selectAllOption: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Bottom sheet content - grouped',
      fileName: 'bottom_sheet_content_grouped',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Grouped items',
            child: SizedBox(
              width: 350,
              height: 350,
              child: Material(
                child: SelectionContentPreview<String>(
                  choices: groupedChoices,
                  singleSelection: false,
                  selectAllOption: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Bottom sheet content - with header and footer',
      fileName: 'bottom_sheet_content_header_footer',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Header and footer',
            child: SizedBox(
              width: 350,
              height: 400,
              child: Material(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      child: const Text(
                        'Select Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SelectionContentPreview<String>(
                        choices: testChoices,
                        singleSelection: false,
                        selectAllOption: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey.shade100,
                      child: const Text('3 items available'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

/// Helper widget to render SelectionContent in golden tests without
/// needing to open a bottom sheet.
class SelectionContentPreview<T> extends StatelessWidget {
  final List<Choice<T>> choices;
  final bool singleSelection;
  final bool selectAllOption;

  const SelectionContentPreview({
    super.key,
    required this.choices,
    required this.singleSelection,
    required this.selectAllOption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selectAllOption && choices.isNotEmpty)
          ListTile(
            leading: Checkbox(value: false, onChanged: (_) {}),
            title: const Text('All'),
            dense: true,
          ),
        ...choices.where((c) => c.value.isNotEmpty).map((choice) {
          final isGroupTitle = choice.key == null || choice.key!.isEmpty;

          if (isGroupTitle) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
              child: Text(
                choice.value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }

          if (singleSelection) {
            return ListTile(
              leading: const Icon(Icons.radio_button_unchecked),
              title: Text(choice.value),
              dense: true,
            );
          }

          return ListTile(
            leading: Checkbox(value: false, onChanged: (_) {}),
            title: Text(choice.value),
            dense: true,
          );
        }),
      ],
    );
  }
}
