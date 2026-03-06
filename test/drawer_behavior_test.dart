import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_field/core/multi_select.dart';
import 'package:multiselect_field/core/drawer_multi_select_field.dart';
import 'package:multiselect_field/core/multi_select_key_store.dart';

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
  tearDown(() => MultiSelectKeyStore.disposeAll());

  // =========================================================================
  // SCAFFOLD MODE
  // =========================================================================
  group('Drawer - Scaffold mode', () {
    testWidgets('renders selection content directly', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('multi selection works', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final selected = <List<String>>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
              onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2']);
    });

    testWidgets('single selection works', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final selected = <List<String>>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              singleSelection: true,
              data: () => testChoices,
              onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      expect(selected.last, ['2']);
    });

    testWidgets('select all works', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final selected = <List<String>>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              selectAllOption: true,
              data: () => testChoices,
              onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2', '3']);

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selected.last, isEmpty);
    });

    testWidgets('default data pre-selects items', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
              defaultData: [Choice<String>('1', 'Option 1')],
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      // Checkbox widget shows checked for pre-selected item
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, true);
    });

    testWidgets('header and footer render', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
              menuHeader: const Text('Filters'),
              menuFooter: const Text('Apply'),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Filters'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
    });

    testWidgets('menuContent overrides data list', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
              menuContent: const Text('Custom'),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('group titles render', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => groupedChoices,
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Group A'), findsOneWidget);
      expect(find.text('Group B'), findsOneWidget);
    });
  });

  // =========================================================================
  // OVERLAY MODE
  // =========================================================================
  group('Drawer - Overlay mode', () {
    testWidgets('renders trigger with label', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            data: () => testChoices,
          ),
        ),
      ));

      expect(find.text('Filters'), findsOneWidget);
    });

    testWidgets('renders custom child trigger', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            data: () => testChoices,
            child: const Icon(Icons.menu, key: Key('trigger')),
          ),
        ),
      ));

      expect(find.byKey(const Key('trigger')), findsOneWidget);
    });

    testWidgets('opens overlay on tap', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            data: () => testChoices,
          ),
        ),
      ));

      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            enabled: false,
            data: () => testChoices,
          ),
        ),
      ));

      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('multi selection works in overlay', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            data: () => testChoices,
            onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      ));

      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1']);

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();
      expect(selected.last, ['1', '2']);
    });

    testWidgets('onOpened and onClosed fire', (tester) async {
      bool opened = false;
      bool closed = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            data: () => testChoices,
            onOpened: () => opened = true,
            onClosed: () => closed = true,
          ),
        ),
      ));

      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();
      expect(opened, true);

      // Dismiss by tapping barrier
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(closed, true);
    });

    testWidgets('display label updates with selection', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            data: () => testChoices,
            defaultData: [Choice<String>('1', 'Option 1'), Choice<String>('2', 'Option 2')],
          ),
        ),
      ));

      expect(find.text('Filters (2)'), findsOneWidget);
    });
  });

  // =========================================================================
  // CALLBACKS
  // =========================================================================
  group('Drawer - Callbacks', () {
    testWidgets('onChanged fires on user action', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final changed = <int>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
              onChanged: (items) => changed.add(items.length),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(changed, [1]);
    });

    testWidgets('onChanged does NOT fire on defaultData', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final changed = <int>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
              defaultData: [Choice<String>('1', 'Option 1')],
              onChanged: (items) => changed.add(items.length),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      await tester.pumpAndSettle();
      expect(changed, isEmpty);
    });
  });

  // =========================================================================
  // KEY STORE
  // =========================================================================
  group('Drawer - KeyStore', () {
    testWidgets('programmatic open via KeyStore', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final store = MultiSelectKeyStore.of<String>('testFilter');
      store.registerScaffold(scaffoldKey);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              keyDrawer: 'testFilter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
            ),
          ),
          body: ElevatedButton(
            onPressed: () => store.openDrawer(),
            child: const Text('Open'),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('programmatic close via KeyStore', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final store = MultiSelectKeyStore.of<String>('testClose');
      store.registerScaffold(scaffoldKey);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              keyDrawer: 'testClose',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      store.openDrawer();
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      store.closeDrawer();
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('dispose removes store', (tester) async {
      MultiSelectKeyStore.of<String>('temp');
      MultiSelectKeyStore.dispose('temp');

      // Creating a new one should work (fresh store)
      final store = MultiSelectKeyStore.of<String>('temp');
      expect(store, isNotNull);
    });

    testWidgets('different keys create different stores', (tester) async {
      final store1 = MultiSelectKeyStore.of<String>('a');
      final store2 = MultiSelectKeyStore.of<String>('b');
      expect(identical(store1, store2), false);
    });

    testWidgets('same key returns same store', (tester) async {
      final store1 = MultiSelectKeyStore.of<String>('same');
      final store2 = MultiSelectKeyStore.of<String>('same');
      expect(identical(store1, store2), true);
    });

    testWidgets('disposeAll clears all stores', (tester) async {
      MultiSelectKeyStore.of<String>('x');
      MultiSelectKeyStore.of<String>('y');
      MultiSelectKeyStore.disposeAll();

      // New calls should create fresh stores
      final fresh = MultiSelectKeyStore.of<String>('x');
      expect(fresh, isNotNull);
    });

    testWidgets('left position uses openDrawer instead of openEndDrawer', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final store = MultiSelectKeyStore.of<String>('leftDrawer');
      store.registerScaffold(scaffoldKey, position: DrawerPosition.left);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              keyDrawer: 'leftDrawer',
              scaffoldKey: scaffoldKey,
              drawerStyle: const DrawerStyle(position: DrawerPosition.left),
              data: () => testChoices,
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      store.openDrawer();
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
    });
  });

  // =========================================================================
  // CLOSE ON SELECT
  // =========================================================================
  group('Drawer - closeOnSelect', () {
    testWidgets('scaffold drawer stays open after selection by default', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              data: () => testChoices,
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Drawer should still be open
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('scaffold drawer closes after selection when closeOnSelect=true', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              closeOnSelect: true,
              data: () => testChoices,
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Drawer should be closed
      expect(find.text('Option 2'), findsNothing);
    });

    testWidgets('overlay drawer closes after selection when closeOnSelect=true', (tester) async {
      final selected = <List<String>>[];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiSelectField<String>.drawer(
            label: 'Filters',
            data: () => testChoices,
            closeOnSelect: true,
            onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
          ),
        ),
      ));

      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Overlay should be closed
      expect(find.text('Option 2'), findsNothing);
      expect(selected.last, ['1']);
    });

    testWidgets('onSelect still fires when closeOnSelect=true', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final selected = <List<String>>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: DrawerMultiSelectField<String>(
              label: 'Filter',
              scaffoldKey: scaffoldKey,
              closeOnSelect: true,
              data: () => testChoices,
              onSelect: (items, _) => selected.add(items.map((e) => e.key!).toList()),
            ),
          ),
          body: const SizedBox(),
        ),
      ));

      scaffoldKey.currentState!.openEndDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      expect(selected.last, ['1']);
    });
  });
}
