import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multiselect field',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'multiselect_field library'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Car? currentCar;

  bool _singleSelection = false;
  bool _useTextForFiltering = false;

  bool _useFooter = false;
  bool _useTitle = false;

  bool _customMultiselectWidget = false;
  bool _customSingleSelectWidget = false;

  bool _useGroupingList = false;

  bool _defaultData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                direction: Axis.horizontal,
                spacing: 3,
                children: [
                  Chip(
                    label: const Text('Use grouping on List'),
                    deleteIcon: _useGroupingList
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _useGroupingList = !_useGroupingList;
                      });
                    },
                  ),
                  Chip(
                    label: const Text('Single selection'),
                    deleteIcon: _singleSelection
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _singleSelection = !_singleSelection;
                      });
                    },
                  ),
                  Chip(
                    label: const Text('Use text for filtering'),
                    deleteIcon: _useTextForFiltering
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _useTextForFiltering = !_useTextForFiltering;
                      });
                    },
                  ),
                  Chip(
                    label: const Text('Use footer'),
                    deleteIcon: _useFooter
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _useFooter = !_useFooter;
                      });
                    },
                  ),
                  Chip(
                    label: const Text('Use title'),
                    deleteIcon: _useTitle
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _useTitle = !_useTitle;
                      });
                    },
                  ),
                  Chip(
                    label: const Text('Default data'),
                    deleteIcon: _defaultData
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _defaultData = !_defaultData;
                      });
                    },
                  ),
                  Chip(
                    label: const Text('Custom multiselect widget'),
                    deleteIcon: _customMultiselectWidget
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _customMultiselectWidget = !_customMultiselectWidget;
                      });
                    },
                  ),
                  Chip(
                    label: const Text('Custom single select widget'),
                    deleteIcon: _customSingleSelectWidget
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    onDeleted: () {
                      setState(() {
                        _customSingleSelectWidget = !_customSingleSelectWidget;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MultiSelectField<Car>(
                title: _useTitle
                    ? (val) => const Text(
                          'Optional Title Widget',
                        )
                    : null,
                defaultData: () => _defaultData ? [picks.first] : [],
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12)),
                footer:
                    _useFooter ? const Text('Optional Footer Widget') : null,
                data: () => _useGroupingList
                    ? picks
                    : picks.where((e) => e.key.isNotEmpty).toList(),
                onSelect: (element) {
                  setState(() {
                    currentCar =
                        element.isNotEmpty ? element.first.metadata : null;
                  });
                },
                singleSelection: _singleSelection,
                useTextFilter: _useTextForFiltering,
                multiSelectWidget: _customMultiselectWidget
                    ? (pick) {
                        return OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(pick.value),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Price: ${pick.metadata?.price}"),
                                        Text("Year: ${pick.metadata?.year}"),
                                        Text(
                                            "sold: ${pick.metadata?.totalSold}"),
                                      ],
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Ok'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(pick.value));
                      }
                    : null,
                singleSelectWidget: _customSingleSelectWidget
                    ? (pick) {
                        return Chip(
                          avatar: Text("${pick.metadata?.totalSold}"),
                          label: Text(pick.value),
                        );
                      }
                    : null,
              ),
              if (currentCar != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("First car"),
                    Text("Price: ${currentCar!.price}"),
                    Text("Year: ${currentCar!.year}"),
                    Text("sold: ${currentCar!.totalSold}"),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Additional properties",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListTile(
                title: Text(
                  "textStyleSingleSelection",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: const Text(
                    "Help to create your own style for single selection using the standard widget. For more flexibility, use singleSelectWidget(pick){}."),
              ),
              ListTile(
                title: Text(
                  "padding",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: const Text("Apply padding to the entire widget."),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<Pick<Car>> picks = [
  Pick<Car>('', 'Ferrari'),
  Pick<Car>('2', '488 GTB', metadata: Car(103, 27.500, 2015)),
  Pick<Car>('3', '458 Italia', metadata: Car(99, 22.000, 2009)),
  Pick<Car>('4', 'Portofino', metadata: Car(105, 31.000, 2017)),
  Pick<Car>('5', 'California T', metadata: Car(102, 25.000, 2016)),
  Pick<Car>('6', 'F8 Tributo', metadata: Car(104, 30.000, 2019)),
  Pick<Car>('', 'Porche'),
  Pick<Car>('8', '911 Carrera S', metadata: Car(106, 32.000, 2019)),
  Pick<Car>('9', 'Boxster GTS', metadata: Car(101, 24.000, 2017)),
  Pick<Car>('10', 'Cayman GT4', metadata: Car(105, 30.500, 2020)),
  Pick<Car>('11', 'Macan Turbo', metadata: Car(102, 25.000, 2019)),
  Pick<Car>('', 'Lamborghini'),
  Pick<Car>('13', 'Huracán Evo', metadata: Car(111, 36.500, 2020)),
  Pick<Car>('14', 'Aventador SVJ', metadata: Car(109, 34.000, 2018)),
  Pick<Car>('15', 'Urus', metadata: Car(108, 32.000, 2019)),
  Pick<Car>('16', 'Gallardo LP560-4', metadata: Car(107, 31.000, 2003)),
  Pick<Car>('', 'Bugatti'),
  Pick<Car>('18', 'Chiron Super Sport 300+', metadata: Car(125, 46.500, 2019)),
  Pick<Car>('19', 'La Voiture Noire', metadata: Car(124, 45.000, 2019)),
  Pick<Car>('20', 'Veyron Super Sport', metadata: Car(123, 43.000, 2008)),
  Pick<Car>('21', 'Divo', metadata: Car(122, 42.000, 2014)),
  Pick<Car>('', 'McLaren'),
  Pick<Car>('23', '720S Spider', metadata: Car(113, 36.000, 2019)),
  Pick<Car>('24', '600LT Spider', metadata: Car(112, 35.000, 2017)),
  Pick<Car>('25', 'Speedtail', metadata: Car(114, 37.000, 2020)),
  Pick<Car>('26', '650S GT3', metadata: Car(116, 39.500, 2015)),
];

class Car {
  final num totalSold;
  final num price;
  final int year;

  Car(this.totalSold, this.price, this.year);
}
