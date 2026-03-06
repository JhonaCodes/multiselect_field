import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/drawer_multi_select_field.dart';

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
  group('GOLDEN_DRAWER_OVERLAY_TRIGGER', () {
    goldenTest(
      'Drawer overlay trigger variants',
      fileName: 'drawer_overlay_trigger',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Default trigger',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>.drawer(
                label: 'Filters',
                data: () => testChoices,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Trigger with selection count',
            child: SizedBox(
              width: 300,
              height: 60,
              child: MultiSelectField<String>.drawer(
                label: 'Filters',
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
              child: MultiSelectField<String>.drawer(
                label: 'Filter',
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
              child: MultiSelectField<String>.drawer(
                label: 'Filters',
                enabled: false,
                data: () => testChoices,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Drawer overlay custom child trigger',
      fileName: 'drawer_overlay_custom_trigger',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Icon trigger',
            child: SizedBox(
              width: 60,
              height: 60,
              child: MultiSelectField<String>.drawer(
                label: 'Filter',
                data: () => testChoices,
                child: const Icon(Icons.menu, size: 28),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Chip trigger',
            child: SizedBox(
              width: 150,
              height: 60,
              child: MultiSelectField<String>.drawer(
                label: 'Filter',
                data: () => testChoices,
                child: const Chip(label: Text('Open drawer')),
              ),
            ),
          ),
        ],
      ),
    );
  });

  group('GOLDEN_DRAWER_SCAFFOLD_CONTENT', () {
    goldenTest(
      'Drawer scaffold content - multi selection',
      fileName: 'drawer_scaffold_content_multi',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Multi selection',
            child: SizedBox(
              width: 300,
              height: 400,
              child: Material(
                child: DrawerMultiSelectField<String>(
                  label: 'Filter',
                  scaffoldKey: GlobalKey<ScaffoldState>(),
                  data: () => testChoices,
                  onSelect: (_, _) {},
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Multi selection with select all',
            child: SizedBox(
              width: 300,
              height: 400,
              child: Material(
                child: DrawerMultiSelectField<String>(
                  label: 'Filter',
                  scaffoldKey: GlobalKey<ScaffoldState>(),
                  data: () => testChoices,
                  selectAllOption: true,
                  onSelect: (_, _) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Drawer scaffold content - single selection',
      fileName: 'drawer_scaffold_content_single',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Single selection with radio buttons',
            child: SizedBox(
              width: 300,
              height: 400,
              child: Material(
                child: DrawerMultiSelectField<String>(
                  label: 'Filter',
                  scaffoldKey: GlobalKey<ScaffoldState>(),
                  singleSelection: true,
                  data: () => testChoices,
                  onSelect: (_, _) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Drawer scaffold content - grouped',
      fileName: 'drawer_scaffold_content_grouped',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Grouped items',
            child: SizedBox(
              width: 300,
              height: 400,
              child: Material(
                child: DrawerMultiSelectField<String>(
                  label: 'Filter',
                  scaffoldKey: GlobalKey<ScaffoldState>(),
                  data: () => groupedChoices,
                  onSelect: (_, _) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Drawer scaffold content - with header and footer',
      fileName: 'drawer_scaffold_content_header_footer',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Header and footer',
            child: SizedBox(
              width: 300,
              height: 400,
              child: Material(
                child: DrawerMultiSelectField<String>(
                  label: 'Filter',
                  scaffoldKey: GlobalKey<ScaffoldState>(),
                  data: () => testChoices,
                  onSelect: (_, _) {},
                  menuHeader: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue.shade50,
                    child: const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  menuFooter: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade100,
                    child: const Text('Apply filters'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
