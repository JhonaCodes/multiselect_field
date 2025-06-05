import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';

final decoration = BoxDecoration(
  color: Colors.grey,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.black),
);

const constraint = BoxConstraints(maxWidth: 600);

void main() {
  group('GOLDEN_TEST_ADVANCED', () {
    /// Test para verificar el comportamiento del menú con opciones agrupadas
    goldenTest(
      'Menu with grouped options',
      fileName: 'menu_grouped_options',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Grouped options',
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => [
                  Choice('', 'Group 1'),
                  Choice('1', 'Option 1'),
                  Choice('2', 'Option 2'),
                  Choice('', 'Group 2'),
                  Choice('3', 'Option 3'),
                  Choice('4', 'Option 4'),
                ],
                onSelect: (selected, isFromDefault) {},
                decoration: decoration,
                menuHeight: 300,
                menuWidth: 250,
              ),
            ),
          ),
        ],
      ),
    );

    /// Test para verificar el comportamiento del menú con opción "Seleccionar todo"
    goldenTest(
      'Menu with select all option',
      fileName: 'menu_select_all',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Select all',
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => [
                  Choice('1', 'Option 1'),
                  Choice('2', 'Option 2'),
                  Choice('3', 'Option 3'),
                  Choice('4', 'Option 4'),
                ],
                onSelect: (selected, isFromDefault) {},
                decoration: decoration,
                menuHeight: 300,
                menuWidth: 250,
                selectAllOption: true,
              ),
            ),
          ),
        ],
      ),
    );

    /// Test para verificar el comportamiento del menú con búsqueda
    goldenTest(
      'Menu with search',
      fileName: 'menu_search',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Search',
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => [
                  Choice('1', 'Option 1'),
                  Choice('2', 'Option 2'),
                  Choice('3', 'Option 3'),
                  Choice('4', 'Option 4'),
                  Choice('5', 'Option 5'),
                  Choice('6', 'Option 6'),
                ],
                onSelect: (selected, isFromDefault) {},
                decoration: decoration,
                menuHeight: 300,
                menuWidth: 250,
                useTextFilter: true,
              ),
            ),
          ),
        ],
      ),
    );

    /// Test para verificar el comportamiento del menú con selección obligatoria
    goldenTest(
      'Menu with mandatory selection',
      fileName: 'menu_mandatory',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [
          GoldenTestScenario(
            name: 'Mandatory',
            child: SizedBox(
              width: 300,
              height: 400,
              child: MultiSelectField<String>(
                data: () => [
                  Choice('1', 'Option 1'),
                  Choice('2', 'Option 2'),
                ],
                onSelect: (selected, isFromDefault) {},
                decoration: decoration,
                menuHeight: 300,
                menuWidth: 250,
                isMandatory: true,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
