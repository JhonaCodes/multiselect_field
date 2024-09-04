import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';


final decoration = BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
        color: Colors.black
    )
);

const constraint =   BoxConstraints(maxWidth: 600);

void main() {
  /// Text title, footer
  group('GOLDEN_TEST_TITLE_FOOTER', () {

    goldenTest('Title and footer text',
      fileName: 'title_footer',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 600),
        children: [

          GoldenTestScenario(
            name: 'No title and no footer',
            child: MultiSelectField(
              data: ()=>[],
              decoration: decoration,
              onSelect: (value){},
            ),
          ),

          GoldenTestScenario(
            name: 'Title',
            child: MultiSelectField(
              title: (isEmpty) => const Text("Title Optional"),
              decoration: decoration,
              data: ()=>[],
              onSelect: (value){},
            ),
          ),

          GoldenTestScenario(
            name: 'Footer',
            child: MultiSelectField(
              data: ()=>[],
              decoration: decoration,
              onSelect: (value){},
              footer: const Text('Footer Optional.'),
            ),
          ),

          GoldenTestScenario(
            name: 'Title and Footer',
            child: MultiSelectField(
              data: ()=>[],
              decoration: decoration,
              onSelect: (value){},
              title: (isEmpty) => const Text("Title Optional"),
              footer: const Text('Footer Optional.'),
            ),
          ),

        ],
      ),
    );

    goldenTest('Custom title and footer',
      fileName: 'title_footer_custom',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraint,
        children: [

          GoldenTestScenario(
            name: 'Title and footer custom widget',
            child: MultiSelectField(
              title: (isEmpty) => OutlinedButton(onPressed: (){}, child: const Text('Button on Title')),
              footer: const Chip(label: Text('Chip on Footer')),
              data: ()=>[],
              decoration: decoration,
              onSelect: (value){},
            ),
          ),


          GoldenTestScenario(
            name: 'Title custom widget',
            child: MultiSelectField(
              title: (isEmpty) => OutlinedButton(onPressed: (){}, child: const Text('Button on Title')),
              data: ()=>[],
              decoration: decoration,
              onSelect: (value){},
            ),
          ),

          GoldenTestScenario(
            name: 'Footer custom widget',
            child: MultiSelectField(
              data: ()=>[],
              decoration: decoration,
              onSelect: (value){},
              footer: const Chip(label: Text('Chip on Footer')),
            ),
          ),
        ],
      ),
    );

  });


  group('GOLDEN_TEST_DATA', (){

    goldenTest('Default data',
        fileName: 'default_data',
        builder: ()=> GoldenTestGroup(
          scenarioConstraints: constraint,
          children: [

            GoldenTestScenario(
              name: "Default empty",
              child: MultiSelectField(
                decoration: decoration,
                data: ()=>[],
                onSelect: (value){},
              ),
            ),

            GoldenTestScenario(
                name: "Default single select",
                child: MultiSelectField(
                  decoration: decoration,
                  singleSelection: true,
                  defaultData: ()=>[Pick('1', 'Item')],
                  data: ()=>[],
                  onSelect: (value){},
                ),
            ),

            GoldenTestScenario(
              name: "Default multiple select",
              child: MultiSelectField(
                decoration: decoration,
                defaultData: ()=>[Pick('1', 'Item1'), Pick('2', 'Item2')],
                data: ()=>[],
                onSelect: (value){},
              ),
            ),

          ],
        ),
    );

  });


}




final _PicksData = [
  Pick('1', 'Item1'),
  Pick('2', 'Item2'),
  Pick('3', 'Item3'),
  Pick('4', 'Item4'),
  Pick('5', 'Item5'),
];