import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/multi_select_key_store.dart';

void main() {
  final testChoices = [
    Choice<String>('1', 'Alpha'),
    Choice<String>('2', 'Beta'),
    Choice<String>('3', 'Gamma'),
  ];

  tearDown(() {
    MultiSelectKeyStore.disposeAll();
  });

  Widget buildApp({
    List<Choice<String>> Function()? data,
    void Function(List<Choice<String>>, bool)? onSelect,
    List<Choice<String>>? defaultData,
    Widget? menuContent,
    Widget? menuHeader,
    Widget? menuFooter,
    bool singleSelection = false,
    bool selectAllOption = false,
    String? keyDrawer,
  }) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        endDrawer: Drawer(
          child: MultiSelectField<String>.drawer(
            label: 'Test',
            keyDrawer: keyDrawer ?? 'test',
            scaffoldKey: scaffoldKey,
            data: data ?? () => testChoices,
            onSelect: onSelect,
            defaultData: defaultData,
            menuContent: menuContent,
            menuHeader: menuHeader,
            menuFooter: menuFooter,
            singleSelection: singleSelection,
            selectAllOption: selectAllOption,
          ),
        ),
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }

  group('DrawerMultiSelectField', () {
    testWidgets('renders selection content when drawer opens', (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);
    });

    testWidgets('multi selection works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildApp(
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(selected?.length, 1);
      expect(selected?.first.key, '1');

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(selected?.length, 2);
    });

    testWidgets('single selection works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildApp(
        singleSelection: true,
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(selected?.length, 1);
      expect(selected?.first.key, '1');

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(selected?.length, 1);
      expect(selected?.first.key, '2');
    });

    testWidgets('select all works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildApp(
        selectAllOption: true,
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected?.length, 3);
    });

    testWidgets('renders header and footer', (tester) async {
      await tester.pumpWidget(buildApp(
        menuHeader: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Header'),
        ),
        menuFooter: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Footer'),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('renders custom menuContent', (tester) async {
      await tester.pumpWidget(buildApp(
        menuContent: const Text('Custom Content'),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Content'), findsOneWidget);
    });

    testWidgets('renders group titles', (tester) async {
      final groupedChoices = [
        Choice<String>(null, 'Group 1'),
        Choice<String>('1', 'Item A'),
        Choice<String>(null, 'Group 2'),
        Choice<String>('2', 'Item B'),
      ];

      await tester.pumpWidget(buildApp(data: () => groupedChoices));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Group 1'), findsOneWidget);
      expect(find.text('Group 2'), findsOneWidget);
    });

    testWidgets('default data pre-selects items', (tester) async {
      List<Choice<String>>? lastSelected;
      await tester.pumpWidget(buildApp(
        defaultData: [Choice<String>('1', 'Alpha')],
        onSelect: (choices, _) => lastSelected = choices,
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Alpha should already be checked, tap Beta to add
      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(lastSelected?.length, 2);
    });
  });

  group('DrawerMultiSelectField - Overlay Mode', () {
    Widget buildOverlayApp({
      List<Choice<String>> Function()? data,
      void Function(List<Choice<String>>, bool)? onSelect,
      List<Choice<String>>? defaultData,
      Widget? menuHeader,
      Widget? menuFooter,
      DrawerStyle? drawerStyle,
      VoidCallback? onOpened,
      VoidCallback? onClosed,
      bool enabled = true,
      Widget? child,
      bool singleSelection = false,
      bool selectAllOption = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Overlay',
            data: data ?? () => testChoices,
            onSelect: onSelect,
            defaultData: defaultData,
            menuHeader: menuHeader,
            menuFooter: menuFooter,
            drawerStyle: drawerStyle,
            onOpened: onOpened,
            onClosed: onClosed,
            enabled: enabled,
            child: child,
            singleSelection: singleSelection,
            selectAllOption: selectAllOption,
          ),
        ),
      );
    }

    testWidgets('renders trigger with label', (tester) async {
      await tester.pumpWidget(buildOverlayApp());
      expect(find.text('Overlay'), findsOneWidget);
    });

    testWidgets('renders custom child trigger', (tester) async {
      await tester.pumpWidget(buildOverlayApp(
        child: const Text('Custom Trigger'),
      ));
      expect(find.text('Custom Trigger'), findsOneWidget);
    });

    testWidgets('opens overlay drawer on tap', (tester) async {
      await tester.pumpWidget(buildOverlayApp());

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(buildOverlayApp(enabled: false));

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('calls onOpened/onClosed', (tester) async {
      var opened = false;
      var closed = false;
      await tester.pumpWidget(buildOverlayApp(
        onOpened: () => opened = true,
        onClosed: () => closed = true,
      ));

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();
      expect(opened, isTrue);

      // Tap barrier to dismiss
      await tester.tapAt(const Offset(10, 300));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('multi selection works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildOverlayApp(
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(selected?.length, 1);

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(selected?.length, 2);
    });

    testWidgets('single selection works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildOverlayApp(
        singleSelection: true,
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(selected?.length, 1);
      expect(selected?.first.key, '1');
    });

    testWidgets('select all works', (tester) async {
      List<Choice<String>>? selected;
      await tester.pumpWidget(buildOverlayApp(
        selectAllOption: true,
        onSelect: (choices, _) => selected = choices,
      ));

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected?.length, 3);
    });

    testWidgets('drawer position left aligns to left', (tester) async {
      await tester.pumpWidget(buildOverlayApp(
        drawerStyle: const DrawerStyle(position: DrawerPosition.left),
      ));

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();

      final align = tester.widget<Align>(find.byType(Align).last);
      expect(align.alignment, Alignment.centerLeft);
    });

    testWidgets('default data updates label', (tester) async {
      await tester.pumpWidget(buildOverlayApp(
        defaultData: [Choice<String>('1', 'Alpha'), Choice<String>('2', 'Beta')],
      ));

      expect(find.text('Overlay (2)'), findsOneWidget);
    });

    testWidgets('header and footer render', (tester) async {
      await tester.pumpWidget(buildOverlayApp(
        menuHeader: const Text('Header'),
        menuFooter: const Text('Footer'),
      ));

      await tester.tap(find.text('Overlay'));
      await tester.pumpAndSettle();

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });
  });

  group('MultiSelectKeyStore', () {
    testWidgets('openDrawer opens scaffold drawer', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      // Register store eagerly (as user code would do)
      final store = MultiSelectKeyStore.of<String>('programmatic');
      store.registerScaffold(scaffoldKey);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            endDrawer: Drawer(
              child: MultiSelectField<String>.drawer(
                label: 'Filter',
                keyDrawer: 'programmatic',
                scaffoldKey: scaffoldKey,
                data: () => testChoices,
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      store.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('closeDrawer closes scaffold drawer', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final store = MultiSelectKeyStore.of<String>('closable');
      store.registerScaffold(scaffoldKey);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            endDrawer: Drawer(
              child: MultiSelectField<String>.drawer(
                label: 'Filter',
                keyDrawer: 'closable',
                scaffoldKey: scaffoldKey,
                data: () => testChoices,
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      store.openDrawer();
      await tester.pumpAndSettle();
      expect(scaffoldKey.currentState?.isEndDrawerOpen, isTrue);

      store.closeDrawer();
      await tester.pumpAndSettle();
      expect(scaffoldKey.currentState?.isEndDrawerOpen, isFalse);
    });

    test('creates and retrieves stores by name', () {
      final store1 = MultiSelectKeyStore.of<String>('test1');
      final store2 = MultiSelectKeyStore.of<String>('test1');
      expect(identical(store1, store2), isTrue);
    });

    test('different names create different stores', () {
      final store1 = MultiSelectKeyStore.of<String>('a');
      final store2 = MultiSelectKeyStore.of<String>('b');
      expect(identical(store1, store2), isFalse);
    });

    test('dispose removes store', () {
      MultiSelectKeyStore.of<String>('disposable');
      MultiSelectKeyStore.dispose('disposable');
      // New instance created
      final newStore = MultiSelectKeyStore.of<String>('disposable');
      expect(newStore, isNotNull);
    });
  });
}
